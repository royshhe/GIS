USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicleClass]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To update a vehicle class
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        	Comments
Don K	Aug 9 1999  	Added @IncludedFPOAmount
NP	Jan 13 2000	Add audit information
Andy Z  Dec 16 2010      Added fields: 'Maestro Code', 'SIPP', 'DisplayOrder','Alias','Acctg_Segment','Default_optional_extra_ID'
*/
CREATE PROCEDURE [dbo].[UpdateVehicleClass]
@VehicleClassCode char(1),
@VehicleType varchar(18),
@VehicleClassName varchar(25),
@UpgradedVehicleClass varchar(25),
@DepositAmount varchar(20),
@MinimumCancellationNotice varchar(4),
@MinimumDriverAge char(2),
@CashRentalAllowed char(1),
@USBorderCrossingAllowed char(1),
@LocalRentalOnly char(1),
@IncludedFPOAmount varchar(11),
@FAVehicleType varchar(18),
@MaestroCode varchar(6),
@SIPP varchar(10),
@DisplayOrder varchar(4),
@Alias varchar(30),
@AcctgSegmt varchar(15),
@DeftOptExtraId varchar(4),
@Description varchar(100),
@LastUpdatedBy varChar(20)
AS
Declare @thisUpgradedVehicleClassCode char(1)
Select @thisUpgradedVehicleClassCode =
	(Select
		Vehicle_Class_Code
	From
		Vehicle_Class
	Where
		Vehicle_Class_Name = @UpgradedVehicleClass)
Update
	Vehicle_Class
Set
	Vehicle_Class_Name = @VehicleClassName,
	Local_Rental_Only = Convert(bit,@LocalRentalOnly),
	US_Border_Crossing_Allowed = Convert(bit,@USBorderCrossingAllowed),
	Cash_Rental_Allowed = Convert(bit,@CashRentalAllowed),
	Deposit_Amount = Convert(smallmoney,@DepositAmount),
	Minimum_Cancellation_Notice = Convert(tinyint,@MinimumCancellationNotice),
	Minimum_Age = Convert(tinyint,@MinimumDriverAge),
	Vehicle_Type_ID = @VehicleType,
	Upgraded_Vehicle_Class_Code = @thisUpgradedVehicleClassCode,
	Included_FPO_Amount = Convert(decimal(9,2), NULLIF(@IncludedFPOAmount, '')),
	FA_Vehicle_Type_ID=@FAVehicleType,
	Last_Updated_By = @LastUpdatedBy,
	Last_Updated_On = GetDate(),
	Maestro_Code = @MaestroCode,
	SIPP = @SIPP,
	DisplayOrder = Convert(int,@DisplayOrder),
	Alias = @Alias,
	Acctg_Segment = @AcctgSegmt,
	Default_Optional_Extra_ID = Convert(smallint ,@DeftOptExtraId),
	Description=@Description
Where
	Vehicle_Class_Code=@VehicleClassCode
Return 1

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
