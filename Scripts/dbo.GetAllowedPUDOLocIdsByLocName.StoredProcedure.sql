USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllowedPUDOLocIdsByLocName]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Replace GetAllowedPickUpIdsByLocName

CREATE PROCEDURE [dbo].[GetAllowedPUDOLocIdsByLocName]

	@LocName varchar(100)
AS

SELECT  distinct dbo.AllowedPickupLocation.AllowedPickUPLocationID,
		L.Location,
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
		L.Percentage_Fee,
		L.Flat_Fee,		
		L.LicenseFeePerDay,
		L.LicenseFeePercentage, 
		L.LicenseFeeFlat,		
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

			    l.Address_1 +(Case when l.Address_2 is not null and  l.Address_2<>'' then ','+l.Address_2 else '' End)  as address, 
				l.City, 
				l.Province, 
				l.Postal_Code,
				l.Phone_Number,
				l.LocationName,
				l.Email_Hour_Description,
				l.isAirportLocation,
				l.CounterCode,
				l.TK_CounterCode,
				l.Nearby_Airport_location,
				(Case When OC.wizard_location=1 Then '1' Else '0' End) wizard_location

--select *
FROM         dbo.AllowedPickupLocation INNER JOIN
                      dbo.Location  ON dbo.AllowedPickupLocation.LocationID = dbo.Location.Location_ID
				inner join dbo.location L on dbo.AllowedPickupLocation.AllowedPickUPLocationID = L.Location_ID
				INNER JOIN dbo.Owning_Company OC
				ON L.Owning_Company_ID = OC.Owning_Company_ID  
where  dbo.Location.Location=@LocName


GO
