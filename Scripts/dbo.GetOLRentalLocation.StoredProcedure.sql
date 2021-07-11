USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOLRentalLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetOLRentalLocation] 
	@CSAOnly Bit
AS


	
	SELECT L.LocationName,
		 L.Location_ID,
		 L.Fuel_Price_Per_Liter,
		 L.Fuel_Price_Per_Liter_Diesel,
		 L.FPO_Fuel_Price_Per_Liter,

		 L.FPO_Fuel_Price_Per_Liter_Dsel,
		 L.Grace_Period,
		 /*"Flag" =
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
			End,*/
		Percentage_Fee,
		Flat_Fee,		
		LicenseFeePerDay,
		LicenseFeePercentage, 
		LicenseFeeFlat		

	FROM	Location L
	WHERE	L.Delete_Flag = 0
		And L.Rental_Location = 1
		And L.Delete_Flag=0
		And Sell_Online=1
		And (L.CSA=@CSAOnly or @CSAOnly=0)
				
		-- Disable this logic for now
                --and (L.Owning_Company_ID IN 	(SELECT	CONVERT(SmallInt, Code)
		--				FROM	Lookup_Table
		--				WHERE	Category = 'BudgetBC Company'
		--			)
                --or L.Owning_Company_ID IN (7409,7412))
                and  Province ='British Columbia'	

	ORDER BY L.Location
	RETURN @@ROWCOUNT
GO
