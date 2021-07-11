USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateLocationVehSpecFee]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[UpdateLocationVehSpecFee] 
	@FeeID varchar(5),
	@VehicleCode varchar(1),
	@FeeDes varchar(30),
	@FeeType varchar(20),
	@FeeAmount varchar(10),
	@ValidFrom varchar(20),
	@ValidTo varchar(20) = '12/31/2078',
	@LocID varchar(5),
	@VehSpecFeeID varchar(5)
AS
DECLARE @sValidFrom datetime,
	 @sValidTo datetime

SELECT @sValidTo = CASE WHEN @ValidTo = '' 
		THEN '12/31/2078'
		ELSE @ValidTo
		END
SELECT @sValidFrom = convert(datetime, @ValidFrom),
	@sValidTo = convert(datetime, @sValidTo)

IF @FeeType = 'Flat'
BEGIN
	UPDATE LocationVC_Specific_Fee
	SET Fee_Type = @FeeID, Vehicle_Class_Code = @VehicleCode, Fee_Description = @FeeDes, Flat_Fee = @FeeAmount, percentage_fee = null, per_day_fee = null, Valid_From = @sValidFrom, Valid_To = @sValidTo
	WHERE LocationVC_Specific_Fee_ID = @VehSpecFeeID
END
ELSE IF @FeeType = 'Percent'
BEGIN
	UPDATE LocationVC_Specific_Fee
	SET Fee_Type = @FeeID, Vehicle_Class_Code = @VehicleCode, Fee_Description = @FeeDes, Percentage_Fee = @FeeAmount, flat_fee = null, per_day_fee = null, Valid_From = @sValidFrom, Valid_To = @sValidTo
	WHERE LocationVC_Specific_Fee_ID = @VehSpecFeeID
END
ELSE
BEGIN
	UPDATE LocationVC_Specific_Fee
	SET Fee_Type = @FeeID, Vehicle_Class_Code = @VehicleCode, Fee_Description = @FeeDes, Per_Day_Fee = @FeeAmount, percentage_fee = null, flat_fee = null, Valid_From = @sValidFrom, Valid_To = @sValidTo
	WHERE LocationVC_Specific_Fee_ID = @VehSpecFeeID
END
GO
