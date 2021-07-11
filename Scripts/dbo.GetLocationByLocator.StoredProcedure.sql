USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationByLocator]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2003-12-19
--	Details		ccrs Export
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[GetLocationByLocator]
(
	@Latitude decimal(10,7),
	@Longitude decimal(10,7),
	@LocationType varchar(20)='Both'
)
AS
-- convert strings to datetime
if @LocationType='Both' 
	SELECT 
	Location_ID 
	,LocationName
	,Address_1
	,Address_2
	,City
	,Province
	,Postal_Code
	,Fax_Number
	,Phone_Number
	,Address_Description
	, Email_Hour_Description as Hours_of_Service_Description
	,OnlineImage_small
	,Latitude 
	,Longitude, 
	dbo.DistanceBetween(Latitude,Longitude,@Latitude,@Longitude)DistanceFromAddress
	--,SQRT(POWER(Latitude - @Latitude, 2) + POWER(Longitude - @Longitude, 2)) * 62.1371192 AS DistanceFromAddress 
	FROM Location 
	WHERE Delete_Flag = 0 and Sell_Online=1 AND  --(ABS(Latitude - @Latitude) < 0.25) AND (ABS(Longitude - @Longitude) < 0.25) ORDER BY DistanceFromAddress 
	dbo.DistanceBetween (Latitude,Longitude,@Latitude,@Longitude)<=50 
	and (truck_location=1 or Car_location=1)
Else
	Begin
		  if @LocationType='Car' 
			 SELECT  
			 Location_ID 
			,LocationName
			,Address_1
			,Address_2
			,City
			,Province
			,Postal_Code
			,Fax_Number
			,Phone_Number
			,Address_Description
			, Email_Hour_Description as Hours_of_Service_Description
			,OnlineImage_small
			,Latitude 
			,Longitude, 
			dbo.DistanceBetween(Latitude,Longitude,@Latitude,@Longitude)DistanceFromAddress
			--,SQRT(POWER(Latitude - @Latitude, 2) + POWER(Longitude - @Longitude, 2)) * 62.1371192 AS DistanceFromAddress 
			FROM Location 
			WHERE Delete_Flag = 0 and Sell_Online=1 AND  --(ABS(Latitude - @Latitude) < 0.25) AND (ABS(Longitude - @Longitude) < 0.25) ORDER BY DistanceFromAddress 
			dbo.DistanceBetween (Latitude,Longitude,@Latitude,@Longitude)<=50 
			and Car_location=1
		  Else
			 Begin 
			     If @LocationType='Truck' 
				 SELECT  
				 Location_ID 
				,LocationName
				,Address_1
				,Address_2
				,City
				,Province
				,Postal_Code
				,Fax_Number
				,Phone_Number
				,Address_Description
				, Email_Hour_Description as Hours_of_Service_Description
				,OnlineImage_small
				,Latitude 
				,Longitude, 
				dbo.DistanceBetween(Latitude,Longitude,@Latitude,@Longitude)DistanceFromAddress
				--,SQRT(POWER(Latitude - @Latitude, 2) + POWER(Longitude - @Longitude, 2)) * 62.1371192 AS DistanceFromAddress 
				FROM Location 
				WHERE Delete_Flag = 0 and Sell_Online=1 AND  --(ABS(Latitude - @Latitude) < 0.25) AND (ABS(Longitude - @Longitude) < 0.25) ORDER BY DistanceFromAddress 
				dbo.DistanceBetween (Latitude,Longitude,@Latitude,@Longitude)<=50 
				and Truck_location=1
			End
	End
GO
