USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDropOffLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetDropOffLocations    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetDropOffLocations    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve a list of drop off locations.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetDropOffLocations]
AS
	/* 10/26/99 - return location name and ID instead of name and name */

Set Rowcount 2000

Select Distinct
	L.Location,
	PUDOL.Drop_Off_Location_Id
From
	Pick_Up_Drop_Off_Location PUDOL,
	Location L
Where
	PUDOL.Drop_Off_Location_Id = L.Location_ID
	And L.Rental_Location = 1
	And L.Delete_Flag = 0
Order By L.Location

Return 1














GO
