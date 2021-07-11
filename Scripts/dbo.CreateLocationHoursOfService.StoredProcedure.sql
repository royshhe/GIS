USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLocationHoursOfService]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLocationHoursOfService    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationHoursOfService    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationHoursOfService    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationHoursOfService    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Hours_Of_Service table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLocationHoursOfService]
	@LocationID	VarChar(10),
	@DayOfWeek	VarChar(4),
	@OpenAt		VarChar(5),
	@CloseAt	VarChar(5)
AS
	INSERT INTO Hours_Of_Service
	  (	Location_ID,
		Day_Of_Week,
		Opens_At,
		Closes_At
	  )
	VALUES
	  (	CONVERT(SmallInt, @LocationID),
		CONVERT(SmallInt, @DayOfWeek),
		@OpenAt,
		@CloseAt
	  )
Return 1













GO
