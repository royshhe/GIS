USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_15_Insurance_Replacement_Rental]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Aug 15, 2001
--  Details: 	 create new icbc report
--  Tracker:	 Issue# 1867
---------------------------------------------------------------------------------------

CREATE Procedure [dbo].[RP_SP_Con_15_Insurance_Replacement_Rental]  -- '01 May 2009', '31 May 2009'
(
                 @StartDateInput varchar(30)='Dec 01 2000', 
                 @EndDateInput varchar(30)='Dec 31 2000'
)
AS 

SET NOCOUNT ON 

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = CONVERT(DATETIME, @StartDateInput)
SELECT @EndDate = CONVERT(DATETIME, @EndDateInput)+1

--PRINT ' *************** Closed Contracts For ICBC *************'
--PRINT ' *** Report Period Starts From:'+@StartDateInput+'  To: '+@EndDateInput+'             ***'
--PRINT ' *** Report Time: '+ CONVERT(VARCHAR(30),GETDATE())+'                                   ***'
--PRINT ''

select  Distinct  con.contract_number as 'Contract#',  vc.Vehicle_Type_ID,
			rate.rate_name ,
			PUL.Location AS PickupLocation, 
			DOL.Location AS DropOffLocation,
			 con.Pick_Up_On as PickUpDate ,
			LVOC.Actual_Check_In as ActualCheckIn ,

			DATEDIFF(mi,con.pick_up_on,LVOC.Actual_Check_In )/1440.00 as AcutualDays,

			(Case When (Rate.Calendar_Day_Rate=0 or Rate.Calendar_Day_Rate is Null) Then 
				CEILING(DATEDIFF(mi,con.pick_up_on,LVOC.Actual_Check_In )/1440.00)  
					When Rate.Calendar_Day_Rate=1 Then DATEDIFF(d,con.pick_up_on,LVOC.Actual_Check_In )+1
			End) as RentalDays,
			Rate.Calendar_Day_Rate,
			Vehicle_Licence_Plate,
			Claim_Number, 
			Accident_Type,
			Shop_Name,
			Date_In_Shop,
			Last_Change_On,
			Last_Change_By

FROM Contract con
INNER JOIN
                      dbo.Location AS PUL ON Con.Pick_Up_Location_ID = PUL.Location_ID INNER JOIN
                      dbo.Location AS DOL ON Con.Drop_Off_Location_ID = DOL.Location_ID

Inner Join RP__Last_Vehicle_On_Contract LVOC
	On Con.Contract_Number=LVOC.Contract_Number
 INNER JOIN dbo.Vehicle_Class vc ON con.Vehicle_Class_Code = vc.Vehicle_Class_Code
join  Vehicle_Rate rate
   on con.Rate_ID=rate.Rate_ID and Rate_Assigned_Date between rate.Effective_Date And  rate.Termination_Date
join Rate_Purpose  Purpose on rate.Rate_Purpose_ID=Purpose.Rate_Purpose_ID
join business_transaction bt
   on bt.Transaction_Description = 'Check in'   and bt.contract_number = con.contract_number
	and bt.Transaction_Date >= @StartDate and bt.Transaction_Date < @EndDate
Left  Join (Select Contract_Number,IRH.Vehicle_Licence_Plate,Claim_Number, AccidentType.Value as Accident_Type,Shop_Name,Date_In_Shop,Last_Change_On,Last_Change_By
				from Insurance_Replacement_Renter_History  IRH 
						inner join Lookup_table AccidentType on IRH.Accident_Type= AccidentType.Code 
						where AccidentType.Category= 'Accident Type') IRRH 
					on con.Contract_Number=IRRH.Contract_Number

WHERE 
	((Purpose.Rate_Purpose in ('Insurance Replacement', 'Service Shop/Dealership', 'ICBC'))   or (IRRH.Contract_Number Is Not null) )-- (Insurance Replacement, Service Shop/Dealership)
	AND con.status='ci'


ORDER BY rate.Rate_Name,con.Contract_Number,Last_Change_On


RETURN @@ROWCOUNT

GO
