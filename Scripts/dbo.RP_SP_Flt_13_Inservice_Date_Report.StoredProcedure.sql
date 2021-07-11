USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_13_Inservice_Date_Report]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Roy He
-- Date:	Dec 20 2004
-- Purpose: 	Adhoc report for Inservice Date (for all non-sold vehicles)
--		
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RP_SP_Flt_13_Inservice_Date_Report]
As

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	

SELECT    mf.[value] AS Manufacturer, 
           v.Unit_Number AS 'Unit Number', 
	   v.Serial_Number AS 'Serial Number', 
           vm.Model_Year AS 'Year', 
           vm.Model_Name AS Model, 
           v.Current_Km AS KM, 
           v.Ownership_Date AS 'Transfer Date',
           vs.[value]  as StatusAfterOwned, 
           dbo.UpdatedVehicleISD(v.Unit_Number)	 as EffectiveDate, 
           --v.Current_Licence_Plate AS Licence, 
	   l.Location
           
           
FROM         dbo.Vehicle v LEFT OUTER JOIN
                      dbo.RP_FLT_Vehicle_AfterOwned_Status_vw VSAfterOwned ON v.Unit_Number = VSAfterOwned.Unit_Number 
--		Left Outer Join  dbo.FA_Inservcie_Date_vw InServiceDate 
--			ON v.Unit_Number = InServiceDate.Unit_Number 

		   LEFT OUTER JOIN
                      dbo.Vehicle_Model_Year vm ON vm.Vehicle_Model_ID = v.Vehicle_Model_ID LEFT OUTER JOIN
                          (SELECT     code, value
                            FROM          lookup_table
                            WHERE      Category = 'Manufacturer') mf ON mf.code = vm.Manufacturer_ID
			LEFT OUTER JOIN
		            (
			     select Code , value from lookup_table
			     where Category = 'Vehicle Status'
		      	     ) vs
			     on vs.code =  VSAfterOwned.Vehicle_Status
                       LEFT OUTER JOIN
			    location l 
			    on l.location_id = v.current_location_id
			
where 	v.deleted = 0 
	and v.Owning_Company_ID = @CompanyCode
	and v.Current_Vehicle_Status != 'i'
	and v.Foreign_vehicle_unit_number is null
--order by vs.value, v.unit_number
Order By  mf.[value], vm.Model_Name, vm.Model_Year, v.Unit_number





GO
