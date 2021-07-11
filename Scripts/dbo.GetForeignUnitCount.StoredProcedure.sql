USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetForeignUnitCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/* Get the number of unit number for a given vehicle
    -Created by Kenneth Wong Aug 25, 2005
*/
CREATE PROCEDURE [dbo].[GetForeignUnitCount]
	@ForeignUnitNumber varchar(20),
	@VehLicence varchar(20),
	@Province varchar(100),
	@OwningCompanyID varchar(10)
AS

SELECT count(*) FROM vehicle 
WHERE current_licence_plate = @VehLicence 
and current_licencing_prov_state = @Province
and foreign_vehicle_unit_number = @ForeignUnitNumber
and Owning_company_ID = @OwningCompanyID and Current_Vehicle_Status<>'e' and deleted=0
GO
