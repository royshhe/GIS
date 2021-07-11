USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_5_Reservation_Operator_Performance]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PROCEDURE NAME: RP_SP_Res_5_Reservation_Operator_Performance
PURPOSE: Select all information needed for Reservation Operator Performance Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:   Reservation Operator Performance Report
MOD HISTORY:
Name 		Date		Comments
Vivian Leung	09 Nov 2001	Tracker Issue# 1872:	Included Foreign_Confirm_number
*/
CREATE PROCEDURE [dbo].[RP_SP_Res_5_Reservation_Operator_Performance]  --'01 mar 2015','31 mar 2015','*','*','*','1'
(
	@paramStartCreateDate varchar(20) = '15 April 1999',
	@paramEndCreateDate varchar(20) = '15 April 1999',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramOperatorName varchar(50) = '*',
	@DateRangeFlag		char(1)='1'
)
AS
-- convert strings to datetime
DECLARE	@startCreateDate datetime,
	@endCreateDate datetime

SELECT	@startCreateDate = CONVERT(datetime, '00:00:00 ' + @paramStartCreateDate),
	@endCreateDate	= CONVERT(datetime, '23:59:59 ' + @paramEndCreateDate)	

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpCompanyID varchar(20)

if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpCompanyID='0'
        END
else
	BEGIN
		SELECT @tmpCompanyID = @paramCompanyID
	END 
-- end of fixing the problem

if @DateRangeFlag='1'
BEGIN
SELECT 	
	
	--Reservation.Confirmation_Number,
	--Reservation.Foreign_Confirm_Number,
    	Reservation.Source_Code,
	Confirmation_Number = CASE WHEN Reservation.Foreign_Confirm_Number IS NOT NULL
				        THEN Reservation.Foreign_Confirm_Number
			            	        ELSE Cast(Reservation.Confirmation_Number AS char(20))
			            END,
	Vehicle_Class.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Location.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	Reservation.Pick_Up_On, 
	--ceiling(DATEDIFF(DAY, Reservation.Pick_Up_On, Reservation.Drop_Off_On)) AS Length_Of_Rental,
	Length_Of_Rental = case 	when round(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On), 1) < 24
				then 1
				else ceiling(cast(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On)as decimal(9,2)) / 24)  end,
	Vehicle_Rate.Rate_name,
    	Reservation.Last_Name + ' ' + Reservation.First_Name AS Customer_Name,
     	Reservation_Change_History.Changed_By AS Operator_Name,
		Reservation_Change_History.Changed_On AS Create_Date,
		ResCancel.ResCancelTime as Cancel_Date,    	
    	Lookup_Table.Value AS Reservation_Status,
    	Reservation.Status,
    	Reservation.Reservation_Revenue
FROM 	
	Reservation WITH(NOLOCK)
	left JOIN
	(
		Select 
		  RMT.Confirmation_Number,
		  RMT.ResMadeTime Changed_On, 
		  (Case When ResHist.Changed_By is not Null Then ResHist.Changed_By Else 'Maestro' End) Changed_By
		  from 
		  (
				SELECT     RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResMadeTime
				from 
				(

					SELECT     Confirmation_Number, Changed_On
					FROM         dbo.Reservation_Change_History
					union 

					SELECT  Confirmation_Number, dateadd(hour, -3, Transaction_Date) Changed_On
					FROM  dbo.Maestro
				) RCH
				GROUP BY RCH.Confirmation_Number
			)	RMT
			Left Join dbo.Reservation_Change_History  ResHist
				On RMT.Confirmation_Number=ResHist.Confirmation_Number
				And RMT.ResMadeTime=ResHist.Changed_On
	)	Reservation_Change_History	
		ON Reservation.Confirmation_Number = Reservation_Change_History.Confirmation_Number
	Left Join RP__Reservation_Cancel_Time ResCancel 
		ON Reservation.Confirmation_Number = ResCancel.Confirmation_Number 
 	left JOIN Vehicle_Class
		ON Vehicle_Class.Vehicle_Class_Code = Reservation.Vehicle_Class_Code
 	left JOIN Location
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	left JOIN
    	Vehicle_Rate
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
     		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
     	left JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	left JOIN
    	Lookup_Table
		ON Reservation.Status = Lookup_Table.Code
		AND Lookup_Table.Category = 'Reservation Status'

WHERE 	
 --  (Reservation_Change_History.Changed_On =  (SELECT MIN(rc2.Changed_On)
 --     						FROM Reservation_Change_History AS rc2
 --     						WHERE Reservation_Change_History.Confirmation_Number = rc2.Confirmation_Number))
	--AND
	Reservation.quoted_rate_id is null
	and
	(@paramVehicleClassID = "*" OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramOperatorName = "*" OR Reservation_Change_History.Changed_By = @paramOperatorName)
	AND
	Reservation_Change_History.Changed_On BETWEEN @startCreateDate AND @endCreateDate
	
union

SELECT 	--Reservation.Confirmation_Number,
	--Reservation.Foreign_Confirm_Number,
	
    	Reservation.Source_Code,
	Confirmation_Number = CASE WHEN Reservation.Foreign_Confirm_Number IS NOT NULL
				        THEN Reservation.Foreign_Confirm_Number
			            	        ELSE Cast(Reservation.Confirmation_Number AS char(20))
			            END,
	Vehicle_Class.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Location.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	Reservation.Pick_Up_On, 
	Length_Of_Rental = case 	when round(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On), 1) < 24
				then 1
				else ceiling(cast(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On)as decimal(9,2)) / 24)  end,
	Quoted_Vehicle_Rate.Rate_name,
    	Reservation.Last_Name + ' ' + Reservation.First_Name AS Customer_Name,
     	Reservation_Change_History.Changed_By AS Operator_Name,
    	Reservation_Change_History.Changed_On AS Create_Date,
    	ResCancel.ResCancelTime as Cancel_Date,
    	Lookup_Table.Value AS Reservation_Status,
    	Reservation.Status,
    	Reservation.Reservation_Revenue
FROM 	
	Reservation WITH(NOLOCK)
	left JOIN	
	(
		Select 
		  RMT.Confirmation_Number,
		  RMT.ResMadeTime Changed_On, 
		  (Case When ResHist.Changed_By is not Null Then ResHist.Changed_By Else 'Maestro' End) Changed_By
		  from 
		  (
				SELECT     RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResMadeTime
				from 
				(

					SELECT     Confirmation_Number, Changed_On
					FROM         dbo.Reservation_Change_History
					union 

					SELECT  Confirmation_Number, dateadd(hour, -3, Transaction_Date) Changed_On
					FROM  dbo.Maestro
				) RCH
				GROUP BY RCH.Confirmation_Number
			)	RMT
			Left Join dbo.Reservation_Change_History  ResHist
				On RMT.Confirmation_Number=ResHist.Confirmation_Number
				And RMT.ResMadeTime=ResHist.Changed_On
	)	Reservation_Change_History
	ON Reservation.Confirmation_Number = Reservation_Change_History.Confirmation_Number
	Left Join RP__Reservation_Cancel_Time ResCancel 
	ON Reservation.Confirmation_Number = ResCancel.Confirmation_Number 
 	left JOIN
	Vehicle_Class
	ON Vehicle_Class.Vehicle_Class_Code = Reservation.Vehicle_Class_Code
 	left JOIN
	Location
	ON Reservation.Pick_Up_Location_ID = Location.Location_ID
 	left join 
 	Quoted_Vehicle_rate
 		on Quoted_Vehicle_rate.quoted_rate_id = Reservation.quoted_rate_id	
 	left JOIN
	Owning_Company
	ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
 	left JOIN
	Lookup_Table
	ON Reservation.Status = Lookup_Table.Code
	AND Lookup_Table.Category = 'Reservation Status'

WHERE 
	--(Reservation_Change_History.Changed_On =  (SELECT MIN(rc2.Changed_On)
 --     						FROM Reservation_Change_History AS rc2
 --     						WHERE Reservation_Change_History.Confirmation_Number = rc2.Confirmation_Number))
	--AND
	Reservation.quoted_rate_id is not null
	and
	(@paramVehicleClassID = "*" OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramOperatorName = "*" OR Reservation_Change_History.Changed_By = @paramOperatorName)
	AND
	Reservation_Change_History.Changed_On BETWEEN @startCreateDate AND @endCreateDate
END
ELSE
BEGIN
SELECT 	
	--Reservation.Confirmation_Number,
	--Reservation.Foreign_Confirm_Number,
	
    	Reservation.Source_Code,
	Confirmation_Number = CASE WHEN Reservation.Foreign_Confirm_Number IS NOT NULL
				        THEN Reservation.Foreign_Confirm_Number
			            	        ELSE Cast(Reservation.Confirmation_Number AS char(20))
			            END,
	Vehicle_Class.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Location.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	Reservation.Pick_Up_On, 
	--ceiling(DATEDIFF(DAY, Reservation.Pick_Up_On, Reservation.Drop_Off_On)) AS Length_Of_Rental,
	Length_Of_Rental = case 	when round(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On), 1) < 24
				then 1
				else ceiling(cast(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On)as decimal(9,2)) / 24)  end,
	Vehicle_Rate.Rate_name,
    	Reservation.Last_Name + ' ' + Reservation.First_Name AS Customer_Name,
     	Reservation_Change_History.Changed_By AS Operator_Name,
    	Reservation_Change_History.Changed_On AS Create_Date,
    	ResCancel.ResCancelTime as Cancel_Date,
    	Lookup_Table.Value AS Reservation_Status,
    	Reservation.Status,
    	Reservation.Reservation_Revenue
FROM 	
	Reservation WITH(NOLOCK)
	left JOIN
	 
	(
		Select 
		  RMT.Confirmation_Number,
		  RMT.ResMadeTime Changed_On, 
		  (Case When ResHist.Changed_By is not Null Then ResHist.Changed_By Else 'Maestro' End) Changed_By
		  from 
		  (
				SELECT     RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResMadeTime
				from 
				(

					SELECT     Confirmation_Number, Changed_On
					FROM         dbo.Reservation_Change_History
					union 

					SELECT  Confirmation_Number, dateadd(hour, -3, Transaction_Date) Changed_On
					FROM  dbo.Maestro
				) RCH
				GROUP BY RCH.Confirmation_Number
			)	RMT
			Left Join dbo.Reservation_Change_History  ResHist
				On RMT.Confirmation_Number=ResHist.Confirmation_Number
				And RMT.ResMadeTime=ResHist.Changed_On
	)	Reservation_Change_History
	
 
	ON Reservation.Confirmation_Number = Reservation_Change_History.Confirmation_Number
	Left Join RP__Reservation_Cancel_Time ResCancel 
	ON Reservation.Confirmation_Number = ResCancel.Confirmation_Number 
 	left JOIN
	Vehicle_Class
	ON Vehicle_Class.Vehicle_Class_Code = Reservation.Vehicle_Class_Code
 	left JOIN
	Location
	ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	left JOIN
	Vehicle_Rate
	ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID
	AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
 		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
 	left JOIN
	Owning_Company
	ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
 	left JOIN
	Lookup_Table
	ON Reservation.Status = Lookup_Table.Code
	AND Lookup_Table.Category = 'Reservation Status'

WHERE 
	--(Reservation_Change_History.Changed_On =  (SELECT MIN(rc2.Changed_On)
 --     						FROM Reservation_Change_History AS rc2
 --     						WHERE Reservation_Change_History.Confirmation_Number = rc2.Confirmation_Number))
	--AND
	Reservation.quoted_rate_id is null
	and
	(@paramVehicleClassID = "*" OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramOperatorName = "*" OR Reservation_Change_History.Changed_By = @paramOperatorName)
	AND
	Reservation.Pick_Up_On  BETWEEN @startCreateDate AND @endCreateDate
	
union

SELECT 	--Reservation.Confirmation_Number,
	--Reservation.Foreign_Confirm_Number,
	
    	Reservation.Source_Code,
	Confirmation_Number = CASE WHEN Reservation.Foreign_Confirm_Number IS NOT NULL
				        THEN Reservation.Foreign_Confirm_Number
			            	        ELSE Cast(Reservation.Confirmation_Number AS char(20))
			            END,
	Vehicle_Class.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Location.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	Reservation.Pick_Up_On, 
	Length_Of_Rental = case 	when round(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On), 1) < 24
				then 1
				else ceiling(cast(datediff(hh, reservation.Pick_Up_On, reservation.Drop_Off_On)as decimal(9,2)) / 24)  end,
	Quoted_Vehicle_Rate.Rate_name,
    	Reservation.Last_Name + ' ' + Reservation.First_Name AS Customer_Name,
     	Reservation_Change_History.Changed_By AS Operator_Name,
    	Reservation_Change_History.Changed_On AS Create_Date,
    	ResCancel.ResCancelTime as Cancel_Date,
    	Lookup_Table.Value AS Reservation_Status,
    	Reservation.Status,
    	Reservation.Reservation_Revenue
FROM 	
	Reservation WITH(NOLOCK)
	left JOIN
	(
		Select 
		  RMT.Confirmation_Number,
		  RMT.ResMadeTime Changed_On, 
		  (Case When ResHist.Changed_By is not Null Then ResHist.Changed_By Else 'Maestro' End) Changed_By
		  from 
		  (
				SELECT     RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResMadeTime
				from 
				(

					SELECT     Confirmation_Number, Changed_On
					FROM         dbo.Reservation_Change_History
					union 

					SELECT  Confirmation_Number, dateadd(hour, -3, Transaction_Date) Changed_On
					FROM  dbo.Maestro
				) RCH
				GROUP BY RCH.Confirmation_Number
			)	RMT
			Left Join dbo.Reservation_Change_History  ResHist
				On RMT.Confirmation_Number=ResHist.Confirmation_Number
				And RMT.ResMadeTime=ResHist.Changed_On
	)	Reservation_Change_History	
	ON Reservation.Confirmation_Number = Reservation_Change_History.Confirmation_Number
	Left Join RP__Reservation_Cancel_Time ResCancel 
	ON Reservation.Confirmation_Number = ResCancel.Confirmation_Number 
	left JOIN
	Vehicle_Class
	ON Vehicle_Class.Vehicle_Class_Code = Reservation.Vehicle_Class_Code
	left JOIN
	Location
	ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	left join 
	Quoted_Vehicle_rate
		on Quoted_Vehicle_rate.quoted_rate_id = Reservation.quoted_rate_id	
	left JOIN
	Owning_Company
	ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
	left JOIN
	Lookup_Table
	ON Reservation.Status = Lookup_Table.Code
	AND Lookup_Table.Category = 'Reservation Status'

WHERE 	
--(Reservation_Change_History.Changed_On =  (SELECT MIN(rc2.Changed_On)
--      						FROM Reservation_Change_History AS rc2
--      						WHERE Reservation_Change_History.Confirmation_Number = rc2.Confirmation_Number))
--	AND
	Reservation.quoted_rate_id is not null
	and
	(@paramVehicleClassID = "*" OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramOperatorName = "*" OR Reservation_Change_History.Changed_By = @paramOperatorName)
	AND
	Reservation.Pick_Up_On  BETWEEN @startCreateDate AND @endCreateDate
END




 
GO
