USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetForeignVehInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PURPOSE: To search for and retrieve all units that match on GIS unit # or foreign unit #
MOD HISTORY:
Name	Date        	Comments
*/
create PROCEDURE [dbo].[GetForeignVehInfo]
@OwningCompany varchar(25),
@ForeignUnitNumber varchar(10),
@VehProvince varchar(25),
@VehLicense varchar(10)

AS
select Foreign_Vehicle_Unit_Number,oc.name,Current_Licence_Plate,Current_Licencing_prov_State
from vehicle veh inner join Owning_Company oc on veh.owning_company_id=oc.owning_company_id
where deleted='0' 
		and oc.name=@OwningCompany 
		and current_licencing_prov_state=@VehProvince
		and (foreign_vehicle_unit_number=@ForeignUnitNumber or current_licence_plate=@VehLicense)
		and not(foreign_vehicle_unit_number=@ForeignUnitNumber and current_licence_plate=@VehLicense)

order by Foreign_Vehicle_Unit_Number,Current_Licence_Plate
	
RETURN @@rowcount
















GO
