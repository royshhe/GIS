USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptNonRentalLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetNonRentalLocation    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetNonRentalLocation    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetNonRentalLocation    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetRptNonRentalLocation]
AS
	/* 3/23/99 - cpy modified - added percentage and flat fee
				- # columns should match GetRentalLocation */

	/* return all locations that are not rental locations */
	SELECT 	L.Location,
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
		Percentage_Fee,		
		Flat_Fee,
		LicenseFeePerDay, 
		LicenseFeePercentage, 
		LicenseFeeFlat,
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

	FROM	Location L
	WHERE	L.Delete_Flag = 0
		And L.Rental_Location = 0
		and L.Owning_Company_ID In
						(Select
							Convert(smallint,Code)
						From
							Lookup_Table
						Where
							Category = 'BudgetBC Company')
		and L.Location in ('B-13 VAA','B-17 Car Sales Lot',
							'B-23 Auction Others','B-28 Ford Turn Back Lot',
							'B-29 GM Turn Back Lot','B-29 Park & Held','B-30 Salvage Lot',
							'B-31 Wreck Row', 'B-08 McDonald Road')
	ORDER BY L.Location
	RETURN @@ROWCOUNT


--select * from location
GO
