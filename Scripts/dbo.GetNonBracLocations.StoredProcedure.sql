USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonBracLocations]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetNonBracLocations    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetNonBracLocations    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetNonBracLocations    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetNonBracLocations]
	-- @LocID VarChar(10) = NULL
AS
	/* 4/20/99 - cpy bug fix - only return rental locations */
	/* 5/26/99 - np  added the last 8 columns */

	/* return all locations that are rental locations */
	SELECT 	L.Location,
			L.Location_ID,
			L.Fuel_Price_Per_Liter,
			L.Fuel_Price_Per_Liter_Diesel,
			L.FPO_Fuel_Price_Per_Liter,
			L.FPO_Fuel_Price_Per_Liter_Dsel,
			L.Grace_Period,
			"Flag" = 0,
			Percentage_Fee,
			Flat_Fee,
			LicenseFeePerDay, 
			LicenseFeePercentage, 
			LicenseFeeFlat ,
			"Currency" =
			   CASE When L.Hub_ID In 
						(Select
							Convert(smallint,Code)
						From
							Lookup_Table
						Where
							Category = 'Hub' and Value='USA')
				Then 'US $'
				Else 'Cdn $'
			   End
		 		

	FROM		Location L
	WHERE	L.Delete_Flag = 0
	AND		L.Owning_Company_ID NOT IN 	(	SELECT	CONVERT(SmallInt, Code)
								FROM		Lookup_Table
								WHERE	Category = 'BudgetBC Company'
						)
	AND		L.Rental_Location = 1
	ORDER BY 	L.Location

	RETURN @@ROWCOUNT
GO
