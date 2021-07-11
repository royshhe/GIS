USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IRACS_GET_Vehicle]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2003-12-19
--	Details		ccrs Export
--	Modification:		Name:		Date:		Detail:
--      ???????????? Do we need the license plate for time of the rental or the current license plate number
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[IRACS_GET_Vehicle]   
(
	@CtrctNumber varchar(20)
)

AS

DECLARE @dEndDate Datetime

SELECT @dEndDate = Convert(Datetime, '31 Dec 2078 23:59')



Declare @FirstLicencePlate Varchar(10)
Declare @FirstCurrentLicencingprovState Varchar(30)
Declare @LastLicencePlate Varchar(10)
Declare @LastCurrentLicencingprovState Varchar(30)


SELECT  @FirstLicencePlate=ISNULL(VLH.Licence_Plate_Number, Vehicle.Current_Licence_Plate),
	@FirstCurrentLicencingprovState=ISNULL(VLH.Licencing_Province_State, dbo.Vehicle.Current_Licencing_prov_State)
FROM    dbo.Vehicle_Licence_History VLH INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract LastVOC ON VLH.Unit_Number = LastVOC.Unit_Number INNER JOIN
                      dbo.Vehicle ON VLH.Unit_Number = dbo.Vehicle.Unit_Number  
        AND LastVOC.Checked_Out BETWEEN VLH.Attached_On AND ISNULL(VLH.Removed_On, @dEndDate)

where Contract_number =Convert(int, @CtrctNumber)


SELECT  @LastLicencePlate=ISNULL(VLH.Licence_Plate_Number, Vehicle.Current_Licence_Plate),
	@LastCurrentLicencingprovState=ISNULL(VLH.Licencing_Province_State, dbo.Vehicle.Current_Licencing_prov_State)
FROM    dbo.Vehicle_Licence_History VLH INNER JOIN
                      dbo.Vehicle ON VLH.Unit_Number = dbo.Vehicle.Unit_Number INNER JOIN
                      dbo.RP__First_Vehicle_On_Contract FirstVOC ON VLH.Unit_Number = FirstVOC.Unit_Number
	AND FirstVOC.Checked_Out BETWEEN VLH.Attached_On AND ISNULL(VLH.Removed_On, @dEndDate)

where Contract_number =Convert(int, @CtrctNumber)

SELECT --- FirstVOC.Contract_Number, 
	Convert(Varchar(8),FirstVOC.Unit_Number) VehicleNum , 
	Case when FirstVC.Vehicle_Type_ID='Car' then 'C'
		when FirstVC.Vehicle_Type_ID='Truck' then 'T'
	End  VehicleType, 
	(Case When FirstVC.Maestro_Code is not null then FirstVC.Maestro_Code Else FirstVC.Vehicle_Class_Code End) as VehClass,
	FistVehicleModel.Model_Name VehModel, 
	FirstManufacturer.[Alias] VehMake, 
	Substring(Convert(Varchar(4),FistVehicleModel.Model_Year),3,2) VehYear, 
	FirstVehicle.Serial_Number VinNum, 
	Case When FistVehicleModel.Diesel=0 then 'U'
		Else 'D'
	End FuelType, 
	FirstVehicle.Exterior_Colour ExtColor, 
	FirstVehicle.Ownership_Date DateInFlt, 
	@FirstLicencePlate Plate, 
	@FirstCurrentLicencingprovState AS PlateState, 
	FirstOwningCompany.System_ID FleetOwner, 
	FirstVOC.Km_Out MilesOut, 
	FirstVOC.Km_In MilesIn, 
	FistVehicleModel.Km_Per_Litre VehMPG, 
	'8' AS FuelOut, 
	LTRIM(Rtrim(FirstVOC.Fuel_Level)) FuelIn, 
	FistVehicleModel.Fuel_Tank_Size TankSize, 
	Case when LastVehicle.Unit_Number is not Null then FirstVOC.Actual_Check_In
		Else Null
	End ExchDateTime,
	
	Case 
		When LastVehicle.Unit_Number is Null Then ''
	     	Else	'8888' 
	End AS ExchEmpID,


	Convert(Varchar(8),LastVehicle.Unit_Number) AS ExchVehicleNum, 
	Case when LastVC.Vehicle_Type_ID='Car' then 'C'
		when LastVC.Vehicle_Type_ID='Truck' then 'T'
	End  ExchVehicleType,
	LastVehicleModel.Model_Name AS ExchVehModel, 
	LastManufacturer.[Alias] AS ExchVehMake, 
	(Case 
		when LastVehicleModel.Model_Year is not null then Substring(Convert(Varchar(4),LastVehicleModel.Model_Year),3,2) 
		Else NULL
	End) AS ExchVehYear, 
	LastVehicle.Serial_Number AS ExchVnNum, 
	Case When LastVehicleModel.Diesel=0 then 'U'
	     When LastVehicleModel.Diesel=1   then 'D'
	     Else ''
	End ExchFuelType,
 	 
	LastVehicle.Exterior_Colour AS ExchExtColor, 
	LastVehicle.Ownership_Date AS ExchDateInFlt, 
	Case 
		When LastVehicle.Unit_Number is Null Then Null
	     	Else	@LastLicencePlate 
	End AS ExchPlate, 
	Case 
		When LastVehicle.Unit_Number is Null Then Null
	     	Else	@LastCurrentLicencingprovState 
	End ExchPlateState, 

        Case 
		When LastVehicle.Unit_Number is Null Then Null
	     	Else '2078-12-31' 
	End AS ExchPlateExp, 
	LastOwningCompany.System_ID AS ExchFleetOwner, 
	LastVOC.Km_Out AS ExcMilesOut, 
	LastVOC.Km_In AS ExchMilesIn, 
	LastVehicleModel.Km_Per_Litre AS ExchVehMPG, 
	
	Case 
		When LastVehicle.Unit_Number is Null Then Null
	     	Else	1 
	End AS ExchFuleOut, 	
	LastVOC.Fuel_Level AS ExchFuelIn, 
	LastVehicleModel.Fuel_Tank_Size AS ExchTankSize

FROM         dbo.Vehicle_Model_Year LastVehicleModel INNER JOIN
                      dbo.Vehicle LastVehicle INNER JOIN
                      dbo.Vehicle_Class LastVC ON LastVehicle.Vehicle_Class_Code = LastVC.Vehicle_Class_Code INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract LastVOC ON LastVehicle.Unit_Number = LastVOC.Unit_Number ON 
                      LastVehicleModel.Vehicle_Model_ID = LastVehicle.Vehicle_Model_ID LEFT OUTER JOIN
                      dbo.Lookup_Table LastManufacturer ON LastVehicleModel.Manufacturer_ID = LastManufacturer.Code AND 
                      LastManufacturer.Category = 'Manufacturer' 
		 LEFT OUTER JOIN
                      dbo.Owning_Company LastOwningCompany ON LastVehicle.Owning_Company_ID = LastOwningCompany.Owning_Company_ID	


RIGHT OUTER JOIN
                      dbo.RP__First_Vehicle_On_Contract FirstVOC INNER JOIN
                      dbo.Vehicle FirstVehicle ON FirstVOC.Unit_Number = FirstVehicle.Unit_Number INNER JOIN
                      dbo.Vehicle_Class FirstVC ON FirstVehicle.Vehicle_Class_Code = FirstVC.Vehicle_Class_Code INNER JOIN
                      dbo.Vehicle_Model_Year FistVehicleModel ON FirstVehicle.Vehicle_Model_ID = FistVehicleModel.Vehicle_Model_ID LEFT OUTER JOIN
                      dbo.Lookup_Table FirstManufacturer ON FistVehicleModel.Manufacturer_ID = FirstManufacturer.Code AND 
                      FirstManufacturer.Category = 'Manufacturer' 
LEFT OUTER JOIN
                      dbo.Owning_Company FirstOwningCompany ON FirstVehicle.Owning_Company_ID = FirstOwningCompany.Owning_Company_ID 
ON LastVOC.Contract_Number = FirstVOC.Contract_Number AND 
                      FirstVOC.Unit_Number <> LastVOC.Unit_Number 
WHERE   FirstVOC.Contract_number =Convert(int, @CtrctNumber)
GO
