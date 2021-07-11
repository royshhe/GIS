USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationInfoByHubID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--GetLocationInfoByHubID '*','' ,'01 jun 2004 20:00:00'
--exec GetLocationDropOffLocation '16', 'Jun 01 2004'

CREATE PROCEDURE [dbo].[GetLocationInfoByHubID]  --'Down* airport office' 
	@HubID varchar(20)='*',
	@LocId varchar(20)='',
	@CurrDate varchar(50)=''
AS


DECLARE	@nHubID SmallInt
if @HubID='*' 
  select @HubID='0'
SELECT	@nHubID = CONVERT(SmallInt, NULLIF(@HubID, ''))

	
DECLARE @dCurrDate Datetime
SELECT @CurrDate = NULLIF(@CurrDate,'')
SELECT	@dCurrDate = CAST(FLOOR(CAST(CAST(@CurrDate AS datetime) AS float)) AS datetime)
	
if @LocId='' or @LocId is null
	Begin
	
	
	
		SELECT Distinct	Location_ID,    
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
			rtrim(ltrim(dbo.Lookup_Table.Code)) as Province, 
			Country,
			Postal_Code, 
			Fax_Number, 
			Phone_Number, 
			Address_Description, 
	        Hours_of_Service_Description,
	        Mnemonic_Code,
			IsAirportLocation, 
			Remarks,
			email_hour_description
			,District,Car_Location,Truck_Location
		FROM   dbo.Location INNER JOIN
                       dbo.Lookup_Table ON dbo.Location.Province = dbo.Lookup_Table.[Value]
		
			
		WHERE	Location.Delete_Flag = 0 and (Location.Hub_id=@nHubID or @nHubID=0)  and Location.Rental_Location=1 and  Location.Province ='British Columbia' and (dbo.Lookup_Table.Category = 'Province')
						And Sell_Online=1
	
	End 
else
	Begin

		SELECT Distinct	Location_ID,    
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
				rtrim(ltrim(dbo.Lookup_Table.Code)) as Province, 
				Country, 
				Postal_Code, 
				Fax_Number, 
				Phone_Number, 
				Address_Description, 
		                Hours_of_Service_Description,
		                Mnemonic_Code,
				IsAirportLocation, 
				Remarks,
				email_hour_description,
				District,Car_Location,Truck_Location
		
		FROM         Location,Pick_Up_Drop_Off_Location, dbo.Lookup_Table 
		
		
			
			WHERE	 dbo.Location.Province = dbo.Lookup_Table.[Value] and
		
			Pick_Up_Drop_Off_Location.Drop_Off_Location_ID = Location.Location_ID
			AND	@dCurrDate BETWEEN Pick_Up_Drop_Off_Location.Valid_From AND
					ISNULL(Pick_Up_Drop_Off_Location.Valid_To, @dCurrDate)
			AND	Pick_Up_Drop_Off_Location.Pick_Up_Location_ID = Convert(SmallInt, @LocId)
			--AND	Pick_Up_Drop_Off_Location.Authorized = 1
			--AND  (FREETEXT(Address_1,@SearchAddress) or FREETEXT(Address_2,@SearchAddress) )
			and Location.Delete_Flag = 0 and (Location.Hub_id=@nHubID or @nHubID=0)  and Location.Rental_Location=1
			ORDER BY LocationName
			RETURN @@ROWCOUNT
	
	
	
	
	end
GO
