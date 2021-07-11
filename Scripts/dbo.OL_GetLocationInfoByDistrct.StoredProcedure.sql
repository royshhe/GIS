USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OL_GetLocationInfoByDistrct]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OL_GetLocationInfoByDistrct]  
	@District varchar(100),
	@VehicleTypeSelection varchar(10)
AS
 
    
if @VehicleTypeSelection='CAR'
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
		isnull(email_hour_description,'') as email_hour_description,District,Car_Location,Truck_Location
FROM         dbo.Location
WHERE	Delete_Flag = 0 and District=@District and Rental_Location=1 And Car_Location=1
else
   Begin
	    If @VehicleTypeSelection='Truck'
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
					isnull(email_hour_description,'') as email_hour_description,District,Car_Location,Truck_Location
			FROM         dbo.Location
			WHERE	Delete_Flag = 0 and District=@District and Rental_Location=1 And Truck_Location=1
		Else
			BEGIN
				IF @VehicleTypeSelection='EITHER'
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
						isnull(email_hour_description,'') as email_hour_description,District,Car_Location,Truck_Location
				FROM         dbo.Location
				WHERE	Delete_Flag = 0 and District=@District and Rental_Location=1 
				And (Truck_Location=1 OR Car_Location=1)
			END		
	
End
GO
