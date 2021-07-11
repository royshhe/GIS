USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocVersion]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetLocVersion]
	@LocID	Varchar(10)
AS
	DECLARE	@nLocID Integer
	SELECT	@nLocID = CONVERT(SmallInt, NULLIF(@LocID, ''))

	SELECT 	Location_ID,
			''
	FROM		Location
	WHERE	Location_ID = @nLocID

	RETURN @@ROWCOUNT















GO
