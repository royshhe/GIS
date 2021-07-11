USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocNearByAP]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocGracePeriod    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocGracePeriod    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
Create PROCEDURE [dbo].[GetLocNearByAP]
	@LocationID VarChar(25)
AS
	DECLARE	@nLocationID SmallInt
	SELECT	@nLocationID = CONVERT(SmallInt, NULLIF(@LocationID, ''))

   	SELECT	Distinct Nearby_Airport_location
   	FROM   	Location
	WHERE	Location_ID = @nLocationID
   	RETURN 1















GO
