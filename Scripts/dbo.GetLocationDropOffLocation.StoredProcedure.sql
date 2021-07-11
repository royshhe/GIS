USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationDropOffLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*
PURPOSE: To retrieve all drop off locations defined for a given LocationId
	 that are valid as of AsOfDate
MOD HISTORY:
Name	Date        	Comments
Don K	27 Mar 2000	Do date comparisons to the day
*/
CREATE PROCEDURE [dbo].[GetLocationDropOffLocation]
	@LocationID	varChar(10),
	@AsOfDate	varChar(24),
	@LocType    varchar(10)
AS
	/* 25-nov-99 - return ordered by location name */
	/* 29-Nov-99 - return valid from in the last column*/
	Declare @TempDate SmallDateTime
	Select @TempDate = CAST(FLOOR(CAST(CAST(NULLIF(@AsOfDate, '') AS datetime) AS float)) AS datetime)
	Set Rowcount 2000

   IF @LocType = 'Regular'
		
		SELECT	ID,
			Drop_Off_Location_ID,
			CONVERT(Char(1), Authorized),
			Authorized_Charge,
			Unauthorized_Charge,
			CONVERT(VarChar, Valid_From, 111) Valid_From,
			CONVERT(VarChar, Valid_To, 111) Valid_To,
			CONVERT(VarChar, Valid_From, 111) Valid_From1,
			CONVERT(VarChar, Valid_To, 111) Valid_To1
		FROM	Pick_Up_Drop_Off_Location PUDOL
			JOIN Location L 
			  ON PUDOL.Drop_Off_Location_ID = L.Location_ID
		WHERE	PUDOL.Pick_Up_Location_ID = CONVERT(SmallInt, @LocationID)
		AND	(Valid_To >= @TempDate OR Valid_To IS Null)
		ORDER BY
			L.Location,
			Valid_From DESC  

	ELSE IF @LocType = 'Tour'

		SELECT	ID,
			Drop_Off_Location_ID,
			CONVERT(Char(1), Authorized),
			Authorized_Charge,
			Unauthorized_Charge,
			CONVERT(VarChar, Valid_From, 111) Valid_From,
			CONVERT(VarChar, Valid_To, 111) Valid_To,
			CONVERT(VarChar, Valid_From, 111) Valid_From1,
			CONVERT(VarChar, Valid_To, 111) Valid_To1
		FROM	Tour_Drop_Off_Charge PUDOL
			JOIN Location L 
			  ON PUDOL.Drop_Off_Location_ID = L.Location_ID
		WHERE	PUDOL.Pick_Up_Location_ID = CONVERT(SmallInt, @LocationID)
		AND	(Valid_To >= @TempDate OR Valid_To IS Null)
		ORDER BY
			L.Location,
			Valid_From DESC

RETURN 1
GO
