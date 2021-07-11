USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLocHoursOfService]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Hours_Of_Service table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdLocHoursOfService]
	@LocationID	VarChar(10),
	@DayOfWeek	VarChar(4),
	@OpenAt		VarChar(5),
	@CloseAt	VarChar(5)
AS
	Declare	@nLocationID SmallInt
	Declare	@nDayOfWeek SmallInt

	Select		@nLocationID = CONVERT(SmallInt, NULLIF(@LocationID, ''))
	Select		@nDayOfWeek = CONVERT(SmallInt, NULLIF(@DayOfWeek, ''))

	UPDATE	Hours_Of_Service
	SET	Opens_At	= @OpenAt,
		Closes_At	= @CloseAt

	WHERE	Location_ID	= @nLocationID
	AND		Day_Of_Week	= @nDayOfWeek

Return 1














GO
