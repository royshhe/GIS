USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicleModelYear]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.UpdateVehicleModelYear    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehicleModelYear    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehicleModelYear    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehicleModelYear    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Vehicle_Model_Year and Vehicle_Class_Vehicle_Model_Yr table .
MOD HISTORY:
Name    Date        	Comments
NP	Jan/14/2000	Add audit info.
*/
/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateVehicleModelYear]
@VehicleModelID varchar(25),@Model varchar(25),
@ModelYear varchar(25),@ClassName varchar(25),@ICBCClassName varchar(25),
@ManufacturerID varchar(20),@KmPerLitre varchar(25),
@FuelTankSize varchar(25),@PSTRate varchar(25),
@ForeignModelOnly char(1),@Diesel char(1),@PassengerVehicle char(1),
@PMScheduleID varchar(20),
@LastUpdatedBy VarChar(20)
AS

Set Rowcount 2000
Declare @ClassCode char(1)
Declare @ICBCClassCode char(1)

Declare @nVehicleModelID SmallInt

Select @nVehicleModelID = Convert(smallint, NULLIF(@VehicleModelID, ''))

Select @ClassCode = (Select Vehicle_Class_Code from Vehicle_Class
			where Vehicle_Class_Name=@ClassName)

Select @ICBCClassCode = (Select Vehicle_Class_Code from Vehicle_Class
			where Vehicle_Class_Name=@ICBCClassName)

Update
	Vehicle_Class_Vehicle_Model_Yr
Set
	Vehicle_Class_Code=@ClassCode
Where
	Vehicle_Model_ID=@nVehicleModelID

Update
	Vehicle_Model_Year
Set
	Model_Name=@Model,
	Model_Year=Convert(smallint,NULLIF(@ModelYear,'')),
	Km_Per_Litre=Convert(decimal(6,2),NULLIF(@KmPerLitre,'')),
	Fuel_Tank_Size=Convert(smallint,NULLIF(@FuelTankSize,'')),
	ICBC_Class=@ICBCClassCode,
	Manufacturer_ID=Convert(smallint,NULLIF(@ManufacturerID,'')),
	PST_Rate=Convert(decimal(5,2),NULLIF(@PSTRate,'')),
	Foreign_Model_Only=Convert(bit,@ForeignModelOnly),
	Diesel=Convert(bit,@Diesel),
	Passenger_Vehicle=convert(bit,@PassengerVehicle),
	PM_Schedule_ID=Convert(smallint,NULLIF(@PMScheduleID,'')),
	Last_Updated_By = @LastUpdatedBy,
	Last_Updated_On = GetDate()
Where
	Vehicle_Model_ID=@nVehicleModelID

Return @nVehicleModelID


INSERT INTO [GISDATA].[dbo].[Lookup_Table]
           ([Category]
           ,[Code]
           ,[Value]
           ,[Alias]
           ,[Editable])
     VALUES
           ('Toll Charge Issuer'
			,'T3'
           ,'Toll Bridge'
           ,null
           ,null)





GO
