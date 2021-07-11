USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRBRDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRBRDate    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRBRDate    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetRBRDate]
	@LastClosedFlag Char(1) = '0'
AS
	/* 7/28/99 - added @LastClosedFlag
		- if @LastClosedFlag = 0 or is missing, return the current RBR date
		- if @LastClosedFlag = 1, return the last RBR date closed */

	SELECT	@LastClosedFlag = ISNULL(NULLIF(@LastClosedFlag,''), '0')

	SELECT	Convert(Varchar(20), Max(RBR_Date),106), CONVERT(varchar, GETDATE(), 106)
	FROM	RBR_Date
	WHERE	(@LastClosedFlag = '0'
		   OR
		(@LastClosedFlag IS NOT NULL
		 AND
		 Budget_Close_Datetime IS NOT NULL))

	RETURN @@ROWCOUNT


 












GO
