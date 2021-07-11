USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationHoursOfService]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetLocationHoursOfService    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationHoursOfService    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationHoursOfService    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationHoursOfService    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocationHoursOfService]
	@LocationID	VarChar(10)
AS
	Set Rowcount 2000
	SELECT	Day_Of_Week,
		Opens_At,
		Closes_At
	FROM	Hours_Of_Service
	WHERE	Location_ID = CONVERT(SmallInt, @LocationID)

	ORDER BY
		Day_Of_Week
RETURN 1













GO
