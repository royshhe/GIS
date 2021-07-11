USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleModelYear]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.CreateVehicleModelYear    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicleModelYear    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicleModelYear    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicleModelYear    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Model_Year table.
MOD HISTORY:
Name    Date        	Comments
NP	Jan/14/2000	Add audit info.
 */

CREATE PROCEDURE [dbo].[CreateVehicleModelYear]
@Model varchar(25),@ModelYear varchar(25),
@ClassName varchar(25),@ICBCClassName varchar(25),
@ManufacturerID varchar(20),@KmPerLitre varchar(25),
@FuelTankSize varchar(25),@PSTRate varchar(25),
@ForeignModelOnly char(1),@Diesel char(1),@PassengerVehicle char(1),
@PMScheduleID varchar(20),
@LastUpdatedBy VarChar(20)

AS
Declare @ClassCode char(1)
Declare @ICBCClassCode char(1)
Declare @thisVehicleModelID smallint
--declare @Addendum varchar(25)

Select @ClassCode = (Select Vehicle_Class_Code from Vehicle_Class
			where Vehicle_Class_Name=@ClassName)
Select @ICBCClassCode = (Select Vehicle_Class_Code from Vehicle_Class
			where Vehicle_Class_Name=@ICBCClassName)
--select @Addendum=case	when @classcode='T'
--							then 'PASSengerADDENDUM.rpt'
--						when @classcode='U' or @classcode='6'
--							then 'MustangAddendum.rpt'
--						else ''
--				end
Insert into Vehicle_Model_Year
	(Model_Name,Model_Year,
	Km_Per_Litre,Fuel_Tank_Size,ICBC_Class,
	Manufacturer_ID,PST_Rate,Foreign_Model_Only,
	Diesel, Passenger_Vehicle,PM_Schedule_ID,
	Last_Updated_By, 
	Last_Updated_On)
values
	(@Model,
	Convert(smallint,NULLIF(@ModelYear,'')),
	Convert(decimal(6,2),NULLIF(@KmPerLitre,'')),
	Convert(smallint,NULLIF(@FuelTankSize,'')),
	@ICBCClassCode,
	Convert(smallint,NULLIF(@ManufacturerID,'')),
	Convert(decimal(5,2),NULLIF(@PSTRate,'')),
	Convert(bit,@ForeignModelOnly),
	Convert(bit,@Diesel), 
	convert(bit,@PassengerVehicle),
	--NULLIF(@Addendum,''),
	NULLIF(@PMScheduleID,''),
	@LastUpdatedBy,
	GetDate())
Select @thisVehicleModelID = @@IDENTITY

-- insert a record into vehicle class vehicle model yr table
Insert into Vehicle_Class_Vehicle_Model_Yr
	(Vehicle_Model_ID, Vehicle_Class_Code)
values
	(@thisVehicleModelID, @ClassCode)
				
Return @thisVehicleModelID
GO
