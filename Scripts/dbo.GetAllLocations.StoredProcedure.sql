USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllLocations    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetAllLocations    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of available locations.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllLocations]
AS
	/* 6/16/99 - removed distinct (not needed) */
	/* 	   - added Rental_location */

Set Rowcount 2000
Select
 	L.Location,
	L.Location_ID,
	L.Fuel_Price_Per_Liter,
	L.Fuel_Price_Per_Liter_Diesel,
	L.FPO_Fuel_Price_Per_Liter,
	L.FPO_Fuel_Price_Per_Liter_Dsel,
	L.Grace_Period,
	"Flag" =
		CASE
			When L.Owning_Company_ID In
					(Select
						Convert(smallint,Code)
					From
						Lookup_Table
					Where
						Category = 'BudgetBC Company')
			Then 1
			Else 0
		End,
	Rental_Location 		
From
	Location L
Where
	Delete_Flag = 0
Order By
	Location
Return 1















GO
