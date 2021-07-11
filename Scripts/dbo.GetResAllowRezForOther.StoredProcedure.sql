USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResAllowRezForOther]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetResAllowRezForOther]
	@LocName Varchar(25)
AS
DECLARE @AllowRezForOtherFlag Int
DECLARE @LocId SmallInt
DECLARE @Location Varchar(25)
SELECT @AllowRezForOtherFlag = 0
SELECT @Location = NULLIF(@LocName,"")
SELECT @AllowRezForOtherFlag = 1
	FROM Location
	WHERE Location = @Location
	AND Delete_Flag = 0
	AND ResNet = 1
	AND Rental_Location = 1
	AND AllowResForOther = 1
	SELECT @AllowRezForOtherFlag
	RETURN @AllowRezForOtherFlag

GO
