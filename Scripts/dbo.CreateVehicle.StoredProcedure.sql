USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicle]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










/****** Object:  Stored Procedure dbo.CreateVehicle    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicle    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicle    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicle    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehicle]
@SerialNumber varchar(30),
@MVANumber varchar(20),
@KeyIgnitionCode varchar(20),
@KeyTrunkCode varchar(20),
@ExteriorColour varchar(30),
@InteriorColour varchar(30),
@TurnBackDeadline varchar(20),
@TurnBack varchar(10),
@DontRentPastKm varchar(10),
@ReconDaysAllowed varchar(10),
@MinTimePeriod varchar(10),
@MaxTimePeriod varchar(10),
@DontRentPastDays varchar(10),
@ManufacturerID varchar(10),
@VehicleType varchar(10),
@VehicleClassCode char(1),
@Model varchar(25),
@ModelYear varchar(4),
@DropShipDate varchar(20),
@DealerCode varchar(30),
@CurrentKm varchar(10),
@CurrentLocationID varchar(10),
@ProgramVehicle char(1),
@PlateNumber varchar(20),
@TransferDate varchar(20),
@Comments varchar(255),
@RiskType varchar(10),
@Ownership varchar(25),
@UserName varchar(30)
AS
Declare @VehicleModelID int
Declare @BudgetBCID int
Declare @thisUnitNumber int
Declare @thisProvince varchar(30)
Declare @thisDate datetime
Select @thisDate = getDate()
If @PlateNumber = ''
	Select @thisProvince = ''
Else
	Select @thisProvince = 'British Columbia'
Select @VehicleModelID = (Select Vehicle_Model_ID
			  From Vehicle_Model_Year
			  Where Model_Name=@Model
			  And Model_Year=Convert(int,@ModelYear))
If @VehicleModelID = (null) /* The Model,ModelYear pair is invalid */
	Return -1
Select @BudgetBCID = (Select CONVERT(Int, Code)
			From Lookup_Table
			Where Category='BudgetBC Company')
Insert Into Vehicle
	(Serial_Number,MVA_Number, Key_Ignition_Code, Key_Trunk_Code,
	 Exterior_Colour, Interior_Colour, Turn_Back_Deadline, Maximum_Km, 
	 Do_Not_Rent_Past_Km,
	 Reconditioning_Days_Allowed,
	 Minimum_Days,
	 Maximum_Days,
	 Do_Not_Rent_Past_Days,
	 Vehicle_Class_Code, Vehicle_Model_ID, Current_Vehicle_Status,
	 Vehicle_Status_Effective_On, Dealer_ID,
	 Current_Km, Current_Location_ID,
	 Program, Current_Licence_Plate,
	 Licence_Plate_Attached_On, 
      Comments, 
     Risk_Type,
     Deleted, Owning_Company_ID,
	 Drop_ShipDate, Current_Licencing_Prov_State,Ownership,
	 Last_Update_By, Last_Update_On)
Values
	(@SerialNumber,@MVANumber, @KeyIgnitionCode, @KeyTrunkCode,
	 @ExteriorColour, @InteriorColour, 
	 CONVERT(DateTime, Nullif(@TurnBackDeadline, '')),
	 Convert(int, NULLIF(@TurnBack, '')),
	 Convert(int, NULLIF(@DontRentPastKm, '')),
	 Convert(smallint, NULLIF(@ReconDaysAllowed, '')),
	 Convert(smallint, NULLIF(@MinTimePeriod, '')),
	 Convert(smallint,NULLIF(@MaxTimePeriod, '')),
	 Convert(smallint,NULLIF(@DontRentPastDays, '')),
	 @VehicleClassCode, @VehicleModelID, 'a',
	 Convert(datetime,@DropShipDate), Convert(smallint, NULLIF(@DealerCode, '')),
	 Convert(int,@CurrentKm), Convert(smallint, @CurrentLocationID),
	 Convert(bit,@ProgramVehicle), @PlateNumber,
	 NULLIF(@TransferDate,''), @Comments, 
	NULLIF(@RiskType, ''),	 0, 
	@BudgetBCID,
	 Convert(datetime,@DropShipDate), @thisProvince,
	 NULLIF(@Ownership,''),@UserName, @thisDate)
Select @thisUnitNumber = @@IDENTITY

-- insert a reocrd into vehicle history
Insert Into Vehicle_History
	(Unit_Number,Vehicle_Status,Effective_On)
Values
	(@thisUnitNumber,'a',Convert(datetime,@DropShipDate))

Insert Into Vehicle_RiskType_History
	(Unit_Number,Risk_Type,Effective_On, Last_Update_By)
Values
	(@thisUnitNumber, NULLIF(@RiskType, ''), @thisDate,@UserName)

If @PlateNumber <> ''
	Begin
		-- insert a reocrd into vehicle licence history
		Insert Into Vehicle_Licence_History
			(Unit_Number,Licence_Plate_Number,
			Licencing_Province_State,Attached_On)
		Values
			(@thisUnitNumber,@PlateNumber,'British Columbia',
			Convert(datetime,@TransferDate))

		-- update vehicle audit info
		Update

			Vehicle
		Set
			Current_Vehicle_Status='b',
			Vehicle_Status_Effective_On=Convert(datetime,@TransferDate),
			Ownership_Date=Convert(datetime,@TransferDate)
		Where
			Unit_Number=@thisUnitNumber

		-- insert a reocrd into vehicle history			
		Insert Into Vehicle_History
			(Unit_Number,Vehicle_Status,Effective_On)
		Values
			(@thisUnitNumber,'b',Convert(datetime,@TransferDate))

		-- update vehicle licence audit info		
		Update
			Vehicle_Licence
		Set
			Last_Change_By=@UserName,
			Last_Change_On=@thisDate
		Where
			Licence_Plate_Number=@PlateNumber
			And Licencing_Province_State='British Columbia'
	End

Return @thisUnitNumber





GO
