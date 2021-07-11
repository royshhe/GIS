USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleClass]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To create a new vehicle class
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        	Comments
Don K	Aug 9 1999  	Added @IncludedFPOAmount
NP	Jan 13 2000	Add audit information
Andy Z  Dec 16th 2010    Added fields: 'Maestro Code', 'SIPP', 'DisplayOrder','Alias','Acctg_Segment','Default_optional_extra_ID'
*/
CREATE PROCEDURE [dbo].[CreateVehicleClass]
@VehicleClassCode char(1),
@VehicleType varchar(18),
@VehicleClassName varchar(25),
@UpgradedVehicleClass varchar(20),
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
@LastUpdatedBy VarChar(20)

AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @thisOptionalExtraID smallint
Declare @thisUpgradedVehicleClassCode char(1)
Select @thisUpgradedVehicleClassCode =
	(Select
		Vehicle_Class_Code
	From
		Vehicle_Class
	Where
		Vehicle_Class_Name = @UpgradedVehicleClass)
Insert into Vehicle_Class
	(Vehicle_Class_Code,
	Vehicle_Class_Name,
	Local_Rental_Only,
	US_Border_Crossing_Allowed,
	Cash_Rental_Allowed,
	Deposit_Amount,
	Minimum_Cancellation_Notice,
	Minimum_Age,
	Vehicle_Type_ID,
	Upgraded_Vehicle_Class_Code,
	Included_FPO_Amount,
	FA_Vehicle_Type_ID,
	Last_Updated_By,
	Last_Updated_On,
	Maestro_Code,
	SIPP,
	DisplayOrder,
	Alias,
	Acctg_Segment,
	Default_Optional_Extra_ID,
	Description)
Values
	(@VehicleClassCode,@VehicleClassName,
	Convert(bit,@LocalRentalOnly),Convert(bit,@USBorderCrossingAllowed),
	Convert(bit,@CashRentalAllowed),Convert(smallmoney,@DepositAmount),
	Convert(tinyint,@MinimumCancellationNotice),
	Convert(tinyint,@MinimumDriverAge),@VehicleType,@thisUpgradedVehicleClassCode,
	Convert(decimal(9,2), NULLIF(@IncludedFPOAmount, '')),
	@FAVehicleType,
	@LastUpdatedBy,
	GetDate(),
    @MaestroCode,
	@SIPP,
	Convert(int,@DisplayOrder),
	@Alias,
	@AcctgSegmt,
	Convert(smallint ,@DeftOptExtraId),
	@Description)
Declare OptionalExtraCursor Cursor FAST_FORWARD
For
	(Select Distinct
		Optional_Extra_ID
	From
		Optional_Extra)
Open OptionalExtraCursor
Fetch Next From OptionalExtraCursor Into @thisOptionalExtraID
While (@@Fetch_Status = 0)
	Begin
		Insert Into Optional_Extra_Restriction
			(Vehicle_Class_Code, Optional_Extra_ID)
		Values
			(@VehicleClassCode, @thisOptionalExtraID)
		Fetch Next From OptionalExtraCursor Into @thisOptionalExtraID
	End

Close OptionalExtraCursor
Deallocate OptionalExtraCursor

Return 1

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
