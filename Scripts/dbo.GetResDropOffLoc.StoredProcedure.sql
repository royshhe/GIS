USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDropOffLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To retrieve the locations that are valid drop off locations for a given
	 LocId during CurrDate. 
	 If ResDOLocId is passed, then it is returned in the list even if it is 
	 no longer a valid drop off location during CurrDate.
	 
MOD HISTORY:
Name	Date        	Comments
Don K	Mar 29 2000	Do date comparisons by day
*/
CREATE PROCEDURE [dbo].[GetResDropOffLoc] -- 16, '2012-12-12'
	@LocId Varchar(5),
	@CurrDate Varchar(24),
	@ResDOLocId Varchar(5) = NULL
AS
	DECLARE @dCurrDate Datetime

	SELECT 	@LocId = NULLIF(@LocId,''),
		@CurrDate = NULLIF(@CurrDate,''),
		@ResDOLocId = NULLIF(@ResDOLocId,'')

	SELECT	@dCurrDate = CAST(FLOOR(CAST(CAST(@CurrDate AS datetime) AS float)) AS datetime)

	-- Only return the authorized drop off locations for this pick up LocId
	/* 981016 - cpy - check authorized bit */
	SELECT	B.Location, A.Drop_Off_Location_ID,
			    B.Address_1 +(Case when B.Address_2 is not null and  B.Address_2<>'' then ','+B.Address_2 else '' End)  as address, 
				B.City, 
				B.Province, 
				B.Postal_Code,
				B.Phone_Number,
				B.LocationName,
				B.Email_Hour_Description,
				B.isAirportLocation,
				B.CounterCode,
				B.TK_CounterCode,
				(Case When OC.wizard_location=1 Then '1' Else '0' End) wizard_location
	FROM	Pick_Up_Drop_Off_Location A
	Inner Join 	Location B
	On A.Drop_Off_Location_ID = B.Location_ID
	INNER JOIN dbo.Owning_Company OC
				ON B.Owning_Company_ID = OC.Owning_Company_ID  
	WHERE	
	@dCurrDate BETWEEN A.Valid_From AND
			ISNULL(A.Valid_To, @dCurrDate)
	AND	A.Pick_Up_Location_ID = Convert(SmallInt, @LocId)
	And B.Delete_Flag=0
	AND	A.Authorized = 1
	UNION
	-- if ResDOLocId is provided, then force that location to be returned
	SELECT 	C.Location, C.Location_Id,
			    C.Address_1 +(Case when C.Address_2 is not null and  C.Address_2<>'' then ','+C.Address_2 else '' End)  as address, 
				C.City, 
				C.Province, 
				C.Postal_Code,
				C.Phone_Number,
				C.LocationName,
				C.Email_Hour_Description,
				C.isAirportLocation,
				C.CounterCode,
				C.TK_CounterCode,
				(Case When OC.wizard_location=1 Then '1' Else '0' End) wizard_location
	FROM	Location C
	INNER JOIN dbo.Owning_Company OC
				ON C.Owning_Company_ID = OC.Owning_Company_ID  
	WHERE	C.Location_ID = Convert(SmallInt, @ResDOLocID)
	ORDER BY  Location
	RETURN @@ROWCOUNT
GO
