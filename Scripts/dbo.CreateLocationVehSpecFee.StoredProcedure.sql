USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLocationVehSpecFee]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateLocationVehSpecFee]
	@FeeID varchar(5),
	@VehicleCode varchar(1),
	@FeeDes varchar(30),
	@FeeType varchar(20),
	@FeeAmount varchar(10),
	@ValidFrom varchar(20),
	@ValidTo varchar(20) = '12/31/2078',
	@LocID varchar(5)
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
	INSERT INTO LocationVC_Specific_Fee
	(Location_ID, Vehicle_Class_Code, Fee_Type, Fee_Description, Flat_Fee, Valid_From, Valid_To)
	VALUES (@LocID, @VehicleCode, @FeeID, @FeeDes, @FeeAmount, @sValidFrom, @sValidTo) 
END
ELSE IF @FeeType = 'Percent'
BEGIN
	INSERT INTO LocationVC_Specific_Fee
	(Location_ID, Vehicle_Class_Code, Fee_Type, Fee_Description, Percentage_Fee, Valid_From, Valid_To)
	VALUES (@LocID, @VehicleCode, @FeeID, @FeeDes, @FeeAmount, @sValidFrom, @sValidTo) 
END
ELSE
BEGIN
	INSERT INTO LocationVC_Specific_Fee
	(Location_ID, Vehicle_Class_Code, Fee_Type, Fee_Description, Per_Day_Fee, Valid_From, Valid_To)
	VALUES (@LocID, @VehicleCode, @FeeID, @FeeDes, @FeeAmount, @sValidFrom, @sValidTo) 
END
GO
