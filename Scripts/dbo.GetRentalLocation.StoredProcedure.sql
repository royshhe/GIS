USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRentalLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.GetRentalLocation    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRentalLocation    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRentalLocation    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRentalLocation    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRentalLocation]
	@ResnetOnly char(1) = '0'
AS
	/* 981102 - cpy - added fuel_price_per_litres,
			FPO fuel prices, and grace_period  */
	/* 990223 - Don K - added @ResnetOnly to filter for resnet locations */
	/* 990323 - cpy modified - add location flat and percentage fee
				- # columns should match GetNonRentalLocation */

	/* return all locations that are rental locations */
	/* @ResnetOnly flag is currently used by SP GetResPickUpLoc */

	SELECT L.Location,
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
				Then "US $"
				Else "Cdn $"
			   End,

	    L.Address_1 +(Case when L.Address_2 is not null and  L.Address_2<>'' then ','+L.Address_2 else '' End)  as address, 
		L.City, 
		L.Province, 
		L.Postal_Code,
		L.Phone_Number,
		L.LocationName,
		L.Email_Hour_Description,
		isnull(L.isAirportLocation,0) as isAirportLocation,
		L.CounterCode,
		L.TK_CounterCode,		
		Nearby_Airport_location,
		(Case When OC.wizard_location=1 Then '1' Else '0' End) wizard_location
	FROM	Location L
	INNER JOIN dbo.Owning_Company OC
				ON L.Owning_Company_ID = OC.Owning_Company_ID  
	WHERE	L.Delete_Flag = 0
		And L.Rental_Location = 1
		AND (  L.Resnet = 1
		    OR @ResnetOnly = '0'
		    )
	ORDER BY L.Location
	RETURN @@ROWCOUNT


GO
