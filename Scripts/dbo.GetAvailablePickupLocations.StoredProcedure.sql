USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAvailablePickupLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAvailablePickupLocations    Script Date: 2/18/99 12:12:01 PM ******/
/*
PURPOSE: 	To retrieve a list of locations that can be pickup location.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAvailablePickupLocations]
AS
Set Rowcount 2000
Select Distinct
	L.Location
From
	Location L  WITH(NOLOCK),
	Pick_Up_Drop_Off_Location PUDOL  WITH(NOLOCK)
Where
	L.Location_ID = PUDOL.Pick_Up_Location_Id
	And L.Rental_Location = 1
	And L.Resnet = 1
	And L.Delete_Flag = 0
Order By L.Location

Return 1












GO
