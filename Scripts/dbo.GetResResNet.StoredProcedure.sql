USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResResNet]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResResNet    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResResNet    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResResNet    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResResNet    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResResNet]
	@LocName Varchar(25)
AS
DECLARE @ResNetFlag Int
DECLARE @LocId SmallInt
DECLARE @Location Varchar(25)
	/* a ResNet location has ResNet = 1 and Rental_Location = 0 */
	-- default is 0
	SELECT	@ResNetFlag = 0,
		@LocName = NULLIF(@LocName,"")
	SELECT 	@ResNetFlag = 1
	FROM 	Location
	WHERE 	Location = @LocName
	AND	Delete_Flag = 0
	AND	ResNet = 1
	AND	Rental_Location = 0
	SELECT @ResNetFlag
	RETURN @ResNetFlag













GO
