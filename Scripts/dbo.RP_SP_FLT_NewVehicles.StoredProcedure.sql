USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FLT_NewVehicles]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Roy He
--  Date :         Jun 22, 2002
--  Details: 	   FPO Fuel Adhoc Reports
----------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[RP_SP_FLT_NewVehicles]
       @StartDateInput varchar(30)='Dec 01 2000', 
       @EndDateInput varchar(30)='Dec 31 2000'

AS 

SET NOCOUNT ON 

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = CONVERT(DATETIME, @StartDateInput)
SELECT @EndDate = CONVERT(DATETIME, @EndDateInput)+1

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	

SELECT Vehicle.Unit_Number, Vehicle_Model_Year.Model_Name, 
    Vehicle_Model_Year.Model_Year, Vehicle.Serial_Number, 
    Lookup_Table.Value AS status, Vehicle.Ownership_Date, 
    Vehicle.Current_Km, Vehicle.Drop_ShipDate, 
    ViewVehicleInServiceDate.InService, 
    Vehicle.Turn_Back_Deadline, 
     Order_type = case when vehicle.program = 1
		then 'Program'
		else rt.value
		end,
    /*' ' AS [pull for Disposal], 
    ' ' AS sold, */
    Lookup_Table1.Value AS Manufacturer,Lookup_Table2.Value AS dealer
FROM Vehicle INNER JOIN
    Vehicle_Model_Year ON 
    Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     LEFT OUTER JOIN
    ViewVehicleInServiceDate ON 
    Vehicle.Unit_Number = ViewVehicleInServiceDate.Unit_Number LEFT
     OUTER JOIN
    Lookup_Table Lookup_Table1 ON 
    Vehicle_Model_Year.Manufacturer_ID = Lookup_Table1.Code LEFT
     OUTER JOIN
    Lookup_Table ON 
    Vehicle.Current_Vehicle_Status = Lookup_Table.Code 
    LEFT
     OUTER JOIN
    Lookup_Table Lookup_Table2 ON 
    Vehicle.dealer_ID = Lookup_Table2.Code

	left join (
		select code , value
		from lookup_table
		where Category = 'Risk Type' 
      		) rt
		on rt.Code = Vehicle.Risk_Type


WHERE (Lookup_Table.Category = 'Vehicle Status') AND 
    (Vehicle.Owning_Company_ID = @CompanyCode ) AND 
    (Vehicle.Deleted = 0) AND 
    (Lookup_Table1.Category = 'Manufacturer') AND
    (Lookup_Table2.Category = 'dealer') and 

    (
	(

	(Vehicle.Drop_ShipDate >= @StartDate AND Vehicle.Drop_ShipDate<@EndDateInput) 
	or 
	(Vehicle.Ownership_Date >= @StartDate AND Vehicle.Ownership_Date<@EndDateInput)
    	or 
	(ViewVehicleInServiceDate.InService  >= @StartDate AND ViewVehicleInServiceDate.InService<@EndDateInput) 
        
        ) 

     )
order by Manufacturer, Vehicle.Unit_Number




GO
