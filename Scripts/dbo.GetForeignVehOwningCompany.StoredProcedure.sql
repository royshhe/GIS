USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetForeignVehOwningCompany]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Get the owning company id for a given foreign vehicle licence plate and province
    -Created by Kenneth Wong Aug 25, 2005
*/
CREATE PROCEDURE [dbo].[GetForeignVehOwningCompany]
	@VehLicence varchar(20),
	@Province varchar(100)
AS

Declare @OwningCompanyID Varchar(10)

select @OwningCompanyID = code from lookup_table where category ='BudgetBC Company '



SELECT DISTINCT  (Case When O.Owning_company_id=@OwningCompanyID Then 1 Else 0 End)  OurOwnVehicle--'0000' --O.Owning_company_id
FROM vehicle V with (nolock) left join Owning_company O 
ON V.Owning_company_id = O.Owning_company_id
WHERE V.current_licence_plate = @VehLicence and V.current_licencing_prov_state = @Province
	and V.Current_Vehicle_Status<>'e'

GO
