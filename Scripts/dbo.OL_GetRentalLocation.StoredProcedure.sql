USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OL_GetRentalLocation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OL_GetRentalLocation] --'0', '0'
    @TruckLoc Bit,
	@CSAOnly Bit
AS


	if @TruckLoc=1 
	Begin
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
		LicenseFeeFlat,
		L.TK_CounterCode, 
		L.TK_Mnemonic_Code, 
		L.TK_StationNumber, 
		L.TK_DBRCode
		

	FROM	Location L
	WHERE	L.Delete_Flag = 0
		And L.Rental_Location = 1
		And L.Truck_Location=1 
		And L.Delete_Flag=0
		And Sell_Online=1
		And (L.CSA=@CSAOnly or @CSAOnly=0)
				
 
     --           and (L.Owning_Company_ID IN 	(SELECT	CONVERT(SmallInt, Code)
					--	FROM	Lookup_Table
					--	WHERE	Category = 'BudgetBC Company'
					--	)
					--)
				   and (L.Owning_Company_ID IN 	(7425,7440)
					)
					
                 
                and (Province ='British Columbia'	or Province ='Yukon')
                
               

	ORDER BY L.Location 
	end 
    Else
    Begin
		
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
		LicenseFeeFlat,
		L.TK_CounterCode, 
		L.TK_Mnemonic_Code, 
		L.TK_StationNumber, 
		L.TK_DBRCode
		

	FROM	Location L
	WHERE	L.Delete_Flag = 0
		And L.Rental_Location = 1
		And L.Car_Location=1
		And L.Delete_Flag=0
		And Sell_Online=1
		And (L.CSA=@CSAOnly or @CSAOnly=0)
				
 
     --            and (L.Owning_Company_ID IN 	(SELECT	CONVERT(SmallInt, Code)
					--	FROM	Lookup_Table
					--	WHERE	Category = 'BudgetBC Company'
					--	)
					--) 
                 
               and (Province ='British Columbia'	or Province ='Yukon')

	ORDER BY L.Location 

	End
	   
	RETURN @@ROWCOUNT
GO
