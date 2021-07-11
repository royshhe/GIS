USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptIsRental]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRptIsRental    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRptIsRental    Script Date: 2/16/99 2:05:42 PM ******/
/*
PROCEDURE NAME: GetRptIsRental
PURPOSE: To check if a location is a rental location
AUTHOR: Don Kirkby
DATE CREATED: Jan 28, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptIsRental]
	@LocName	varchar(25)
AS
	SELECT	@LocName = NULLIF(@LocName, '')

	SELECT	CONVERT(tinyint, rental_location)
	  FROM	location
	 WHERE	location = @LocName
	   AND	delete_flag = 0













GO
