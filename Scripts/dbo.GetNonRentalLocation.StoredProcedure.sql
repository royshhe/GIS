USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonRentalLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetNonRentalLocation    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetNonRentalLocation    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetNonRentalLocation    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetNonRentalLocation]
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
			   End,

			    Address_1 +(Case when Address_2 is not null and  Address_2<>'' then ','+Address_2 else '' End)  as address, 
				City, 
				Province, 
				Postal_Code,
				Phone_Number,
				LocationName,
				Email_Hour_Description,
				isAirportLocation,
				CounterCode,
				TK_CounterCode,
				Nearby_Airport_location,
				'0'
	FROM	Location L
	WHERE	L.Delete_Flag = 0
		And L.Rental_Location = 0
	ORDER BY L.Location
	RETURN @@ROWCOUNT

GO
