USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_16_Breakdown_By_Hour_VC]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author: Vinnie Fung
-- Create date: 2017/12/07
-- Description:	Test SP for new report DueBack / Res Breakdown by Hour
-- =============================================
CREATE PROCEDURE [dbo].[RP_SP_Res_16_Breakdown_By_Hour_VC]--'*', '*', '29 Dec 2017'
(
    @paramVehicleTypeID varchar(18) = '*',
    @paramCompanyID	   varchar(20) = '*',
    @paramRBRDate varchar(20) = '01 Oct 1999'
)

AS

DECLARE @RBRDate datetime

SELECT	@RBRDate	= CONVERT(datetime, '00:00:00 ' + @paramRBRDate)


DECLARE  @tmpCompanyID varchar(20)

if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpCompanyID='0'
        END
else
	BEGIN
		SELECT @tmpCompanyID = @paramCompanyID
        END 


--DECLARE  @intHubID varchar(6)

--if @paramHubID = ''
--	select @paramHubID = '*'

--if @paramHubID = '*'
--	BEGIN
--		SELECT @intHubID='0'
--        END
--else
--	BEGIN
--		SELECT @intHubID = @paramHubID
--        END 


--Contracts that are checked out and DUE for specified date
	SELECT	
	
	NULL AS Source_Code,
	NULL AS Status,	
	Vehicle_On_Contract.Expected_Check_In,
    	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)) AS Expected_Check_In_Date,
	DATEPART(hh,  Vehicle_On_Contract.Expected_Check_In) AS Expected_Check_In_Hour,
	Vehicle_Class.Vehicle_Type_ID,
    	--Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
    	Right(Convert(char(03), Vehicle_Class.DisplayOrder+100),2)+' - '+Vehicle_Class.Vehicle_Class_Name Vehicle_Class_Code_Name,			 	-- Vehicle class name
	COUNT(Contract.Contract_Number) AS Contract_Cnt,
	NULL AS Owning_Company_ID,
	NULL AS Company_Name,
	NULL AS Location_ID,
    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID AS Expected_Check_In_Location_ID,
     	Location.Location AS Expected_Check_In_Location_Name,
	NULL AS Res_Cnt
    	

FROM 	Contract with(nolock)
	INNER JOIN
    	Vehicle_On_Contract
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
     	INNER JOIN
    	Vehicle
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
	INNER JOIN
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Location
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 	-- location has to be rental location
	INNER JOIN lookup_table lt1
		ON lt1.Code = Location.Owning_Company_ID
		AND lt1.Category = 'BudgetBC Company'	-- drop off location has to be a BRAC BC location
	INNER JOIN lookup_table lt2
		ON lt2.Code = Vehicle.Owning_Company_ID
		AND lt2.Category = 'BudgetBC Company'	-- BRAC BC vehicles

WHERE 	(Contract.Status = 'CO')
	AND
	(Vehicle_On_Contract.Actual_Check_In IS NULL)
	AND
	Vehicle.Deleted = 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	--(@paramDueBackLocationID = '*' or CONVERT(INT, @tmpLocID) = Vehicle_On_Contract.Expected_Drop_Off_Location_ID)
	--AND
	DATEDIFF(dd, @RBRDate, Vehicle_On_Contract.Expected_Check_In) = 0
	--drop_off_on between '2017-12-29 00:00:00.000' and '2017-12-29 23:59:00.000'
	--AND
	--(@paramHubID = '*' or CONVERT(INT, @intHubID) = location.Hub_ID)

GROUP BY 	
	Vehicle_On_Contract.Expected_Check_In,
    	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)),
	DATEPART(hh, Vehicle_On_Contract.Expected_Check_In),
    	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID,
    	Location.Location,
	Vehicle_Class.Vehicle_Class_Code,Vehicle_Class.DisplayOrder

UNION ALL

--Pre-writes that are DUE on specified date
SELECT	
	
	NULL AS Source_Code,
	'OP' AS Status,	
	Contract.Drop_Off_On,
    	CONVERT(datetime, CONVERT(varchar(12), Contract.Drop_Off_On, 112)) AS Expected_Check_In_Date,
	DATEPART(hh,  Contract.Drop_Off_On) AS Expected_Check_In_Hour,
	Vehicle_Class.Vehicle_Type_ID,
    	--Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
    	Right(Convert(char(03), Vehicle_Class.DisplayOrder+100),2)+' - '+Vehicle_Class.Vehicle_Class_Name Vehicle_Class_Code_Name,			 	-- Vehicle class name
	COUNT(Contract.Contract_Number) AS Contract_Cnt,
	NULL AS Owning_Company_ID,
	NULL AS Company_Name,
	NULL AS Location_ID,
    	Contract.Drop_Off_Location_ID AS Expected_Check_In_Location_ID,
     	Location.Location AS Expected_Check_In_Location_Name,
	NULL AS Res_Cnt
    	

FROM 	Contract with(nolock)
	INNER JOIN
	Vehicle_Class
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Location
		ON Contract.Drop_Off_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 	-- location has to be rental location
	--INNER JOIN lookup_table lt1
	--	ON lt1.Code = Location.Owning_Company_ID
	--	AND lt1.Category = 'BudgetBC Company'	-- drop off location has to be a BRAC BC location
	--INNER JOIN lookup_table lt2
	--	ON lt2.Code = Vehicle.Owning_Company_ID
	--	AND lt2.Category = 'BudgetBC Company'	-- BRAC BC vehicles

WHERE 	(Contract.Status = 'OP')
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	--(@paramDueBackLocationID = '*' or CONVERT(INT, @tmpLocID) = Vehicle_On_Contract.Expected_Drop_Off_Location_ID)
	--AND
	DATEDIFF(dd, @RBRDate, contract.Drop_Off_On)= 0
	--AND
	--(@paramHubID = '*' or CONVERT(INT, @intHubID) = location.Hub_ID)

GROUP BY 	
	Contract.Drop_Off_On,
    	CONVERT(datetime, CONVERT(varchar(12), Contract.Drop_Off_On, 112)),
	DATEPART(hh,  Contract.Drop_Off_On),
    	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Contract.Drop_Off_Location_ID,
    	Location.Location,
	Vehicle_Class.Vehicle_Class_Code,Vehicle_Class.DisplayOrder

UNION ALL

--Reses for PICKUP that are not opened/checked out for specified day
    SELECT 	Reservation.Source_Code,			-- source of reservation
	Reservation.Status,               			-- status of reservation
	Reservation.Pick_up_on,			-- date vehicle is claimed to pick up
	CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)) 	AS Pick_up_date,	-- date vehicle is picked up
	DATEPART(hh, Reservation.Pick_up_on) 			AS Pick_up_hour,	-- hour of the day vehicle is picked up
	Vehicle_Class.Vehicle_Type_ID,				-- vehicle type
	Vehicle_Class.Vehicle_Class_Name,			 	-- Vehicle class name
	--Location.Hub_ID,					 	-- Hub ID
	--Lookup_Table.Value 	AS Hub_Name,			-- Hub Name
	NULL,
	NULL,
	Owning_Company.Owning_Company_ID,			-- company ID
	Owning_Company.Name 	AS Company_Name,        		-- company name
	Location.Location_ID 	AS Location_ID, 			-- location ID
	Location.Location 		AS Location_Name,		-- location name
	COUNT(Reservation.Confirmation_Number) 	AS Res_cnt	-- total count of reservation
FROM 	Location with(nolock)	
	INNER JOIN 	
	Reservation 	
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
		AND Reservation.Status = 'A'
	INNER JOIN	
	Vehicle_Class	
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Owning_Company	
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	--INNER JOIN 	
	--Lookup_Table 	
	--	ON Location.Hub_ID = Lookup_Table.Code
	--	AND Lookup_Table.Category = "Hub"

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	--AND
	--(@paramHubID = "*" or @paramHubID = Location.Hub_ID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpCompanyID) = Owning_Company.Owning_Company_ID)
	AND
	--DATEDIFF(dd, CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)), @RBRDate)= 0
	CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)) <= @RBRDate
GROUP BY 	
	Reservation.Source_Code,
	Reservation.Status,
	Reservation.Pick_up_on,
	CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)),
	DATEPART(hh, Reservation.Pick_Up_On),
	Vehicle_Class.Vehicle_Type_ID,
	Vehicle_Class.Vehicle_Class_Name,
	--Lt1.Category,
	--Location.Hub_ID,
	--Lt1.Value,
	Owning_Company.Owning_Company_ID,
	Owning_Company.Name,
	Location.Location_ID,
	Location.Location,
	Vehicle_Class.DisplayOrder

UNION ALL

--Reses not yet open/checked out DUE for specified date
    SELECT NULL AS Source_Code, 
	 'RD' AS Status,
	 Reservation.Drop_Off_On,
	 CONVERT(datetime, CONVERT(varchar(12), Drop_Off_On, 112)) AS Expected_Check_In_Date, 
	 DATEPART(hh,Reservation.Drop_Off_On) AS Pick_Up_Hour,
	 Vehicle_Class.Vehicle_Type_ID,
	 Right(Convert(char(03), Vehicle_Class.DisplayOrder+100),2)+' - '+Vehicle_Class.Vehicle_Class_Name Vehicle_Class_Code_Name,
	 COUNT(Reservation.Confirmation_Number) AS Contract_Cnt,
	 NULL AS Owning_Company_ID,
	 NULL AS Company_Name,
	 NULL AS Location_ID,
	 Reservation.Drop_Off_Location_ID AS Expected_Check_IN_Location_ID,
	 Location.Location AS Expected_Check_In_Location_Name,
	 NULL AS Res_Count
 FROM Reservation 
	      INNER JOIN Location ON Reservation.Drop_Off_Location_ID = Location.Location_ID
	      INNER JOIN Vehicle_Class ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
WHERE 
      DATEDIFF(dd, CONVERT(datetime, CONVERT(varchar(12), Drop_Off_On, 112)), @RBRDate)= 0 
      --CONVERT(datetime, CONVERT(varchar(12), Drop_Off_On, 112)) <= @RBRDate
      and 
      Reservation.Status = 'A'
GROUP BY
     Reservation.Source_Code,
     Reservation.Status,
     Reservation.Drop_Off_On,
     CONVERT(datetime, CONVERT(varchar(12), Drop_Off_On, 112)),
     DATEPART(hh, Reservation.Drop_Off_On),
      Vehicle_Class.Vehicle_Type_ID,
     Vehicle_Class.Vehicle_Class_Name,
     --Lt1.Category,
     --Location.Hub_ID,
     --Lt1.Value,
     Reservation.Drop_Off_Location_ID,
     Location.Location,
     Vehicle_Class.DisplayOrder
   
UNION ALL

--Reses OPENED but NOT CHECKED OUT for PICKUP
    SELECT NULL AS Source_Code, 
	 'RP' AS Status,
	 Reservation.Pick_Up_On,
	 CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)) AS Expected_Check_In_Date, 
	 DATEPART(hh,Reservation.Pick_up_on) AS Pick_Up_Hour,
	 Vehicle_Class.Vehicle_Type_ID,
	Vehicle_Class.Vehicle_Class_Name,
	 NULL AS Contract_Cnt,
	 NULL AS Owning_Company_ID,
	 NULL AS Company_Name,
	 NULL AS Location_ID,
	 Reservation.Pick_Up_Location_ID AS Expected_Check_IN_Location_ID,
	 Location.Location AS Expected_Check_In_Location_Name,
	 COUNT(Reservation.Confirmation_Number) AS Res_Count
 FROM Reservation 
	      INNER JOIN Location ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	      INNER JOIN Vehicle_Class ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	      INNER JOIN Contract ON Reservation.Confirmation_Number = Contract.Confirmation_Number
WHERE 
      CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)) <= @RBRDate
      --and 
      --CONVERT(datetime, CONVERT(varchar(12), Drop_Off_On, 112)) <= @RBRDate
      and Contract.Status = 'OP'
      and Reservation.Status = 'O'
GROUP BY
     Reservation.Source_Code,
     Reservation.Status,
     Reservation.Pick_Up_On,
     CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)),
     DATEPART(hh, Reservation.Pick_Up_On),
      Vehicle_Class.Vehicle_Type_ID,
     Vehicle_Class.Vehicle_Class_Name,
     --Lt1.Category,
     --Location.Hub_ID,
     --Lt1.Value,
     Reservation.Pick_Up_Location_ID,
     Location.Location,
     Vehicle_Class.DisplayOrder

	
	--order by Vehicle_Class.DisplayOrder

--order by Vehicle_Class.DisplayOrder

RETURN @@ROWCOUNT
GO
