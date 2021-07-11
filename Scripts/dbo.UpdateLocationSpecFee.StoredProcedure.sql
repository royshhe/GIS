USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateLocationSpecFee]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[UpdateLocationSpecFee] 
	@FeeID varchar(5),
	@FeeDes varchar(30),
	@FeeType varchar(20),
	@FeeAmount varchar(10),
	@ValidFrom varchar(20),
	@ValidTo varchar(20) = '12/31/2078',
	@LocID varchar(5),
	@SpecFeeID varchar(5)
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
	UPDATE Location_Specific_Fees
	SET Fee_Type = @FeeID, Fee_Description = @FeeDes, Flat_Fee = @FeeAmount, percentage_fee = null, per_day_fee = null, Valid_From = @sValidFrom, Valid_To = @sValidTo
	WHERE Spec_Fee_ID = @SpecFeeID
END
ELSE IF @FeeType = 'Percent'
BEGIN
	UPDATE Location_Specific_Fees
	SET Fee_Type = @FeeID, Fee_Description = @FeeDes, Percentage_Fee = @FeeAmount, flat_fee = null, per_day_fee = null, Valid_From = @sValidFrom, Valid_To = @sValidTo
	WHERE Spec_Fee_ID = @SpecFeeID
END
ELSE
BEGIN
	UPDATE Location_Specific_Fees
	SET Fee_Type = @FeeID, Fee_Description = @FeeDes, Per_Day_Fee = @FeeAmount, percentage_fee = null, flat_fee = null, Valid_From = @sValidFrom, Valid_To = @sValidTo
	WHERE Spec_Fee_ID = @SpecFeeID
END


	




GO
