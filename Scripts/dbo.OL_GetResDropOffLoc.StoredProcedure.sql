USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OL_GetResDropOffLoc]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
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
Roy He	Mar 29 2011	Do date comparisons by day
*/
CREATE PROCEDURE [dbo].[OL_GetResDropOffLoc] --'20', 1, '2012-12-10'
	@LocId Varchar(5),
	@TruckLoc bit,
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
	if @TruckLoc=1 
	Begin
		SELECT	
			B.LocationName, 
			A.Drop_Off_Location_ID, 
			B.TK_CounterCode, 
			B.TK_Mnemonic_Code, 
			B.TK_StationNumber, 
			B.TK_DBRCode
		FROM	Pick_Up_Drop_Off_Location A Inner Join
			Location B ON A.Drop_Off_Location_ID = B.Location_ID 
	               	
		WHERE	
	 		@dCurrDate BETWEEN A.Valid_From AND
				ISNULL(A.Valid_To, @dCurrDate)
		AND	A.Pick_Up_Location_ID = Convert(SmallInt, @LocId)
		AND B.Truck_Location=1
		AND	A.Authorized = 1
			And B.Delete_flag=0 And B.Sell_Online=1
		UNION
		-- if ResDOLocId is provided, then force that location to be returned
		SELECT 	
			C.LocationName, 
			C.Location_Id,
			C.TK_CounterCode, 
			C.TK_Mnemonic_Code, 
			C.TK_StationNumber, 
			C.TK_DBRCode
		FROM	Location C
		WHERE	C.Location_ID = Convert(SmallInt, @ResDOLocID)
					And C.Delete_flag=0
		ORDER BY LocationName
		RETURN @@ROWCOUNT
	End
	Else
	Begin
	SELECT	
			B.LocationName, 
			A.Drop_Off_Location_ID, 
			B.TK_CounterCode, 
			B.TK_Mnemonic_Code, 
			B.TK_StationNumber, 
			B.TK_DBRCode
		FROM	Pick_Up_Drop_Off_Location A Inner Join
			Location B ON A.Drop_Off_Location_ID = B.Location_ID 
	               	
		WHERE	
	 		@dCurrDate BETWEEN A.Valid_From AND
				ISNULL(A.Valid_To, @dCurrDate)
		AND	A.Pick_Up_Location_ID = Convert(SmallInt, @LocId)
		AND B.Car_Location=1
		AND	A.Authorized = 1
			And B.Delete_flag=0 And B.Sell_Online=1
		UNION
		-- if ResDOLocId is provided, then force that location to be returned
		SELECT 	
			C.LocationName, 
			C.Location_Id,
			C.TK_CounterCode, 
			C.TK_Mnemonic_Code, 
			C.TK_StationNumber, 
			C.TK_DBRCode
		FROM	Location C
		WHERE	C.Location_ID = Convert(SmallInt, @ResDOLocID)
					And C.Delete_flag=0
		ORDER BY LocationName
		RETURN @@ROWCOUNT
	End
GO
