USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationInfoByID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLocationInfoByID] -- '26'
	@LocID varchar(100)	
AS


	DECLARE	@nLocationID SmallInt
	SELECT	@nLocationID = CONVERT(SmallInt, NULLIF(@LocID, ''))


	SELECT 	Location_ID,    
		LocationName, 
		Address=(
			CASE 	
				WHEN Address_2<>''
				THEN Address_1 + ', ' + Address_2
				ELSE Address_1
			
			END
			),
		Address_1, 
		Address_2, 
		City, 
		Province, 
		Postal_Code, 
		Fax_Number, 
		Phone_Number, 
		Address_Description, 
                Hours_of_Service_Description,
                Mnemonic_Code,
		IsAirportLocation, 
		Remarks,
		isnull(email_hour_description,'') as email_hour_description,
		District,Car_Location,Truck_Location
FROM         dbo.Location

	
	WHERE	Delete_Flag = 0 and Location_id=@nLocationID
GO
