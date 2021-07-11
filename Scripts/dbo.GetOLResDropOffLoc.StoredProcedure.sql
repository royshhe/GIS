USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOLResDropOffLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
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
Don K	Mar 29 2000	Do date comparisons by day
*/
create PROCEDURE [dbo].[GetOLResDropOffLoc]
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
	SELECT	B.LocationName, A.Drop_Off_Location_ID
	FROM	Pick_Up_Drop_Off_Location A,
		Location B
	WHERE	A.Drop_Off_Location_ID = B.Location_ID
	AND	@dCurrDate BETWEEN A.Valid_From AND
			ISNULL(A.Valid_To, @dCurrDate)
	AND	A.Pick_Up_Location_ID = Convert(SmallInt, @LocId)
	AND	A.Authorized = 1
        And B.Delete_flag=0 And B.Sell_Online=1
	UNION
	-- if ResDOLocId is provided, then force that location to be returned
	SELECT 	C.LocationName, C.Location_Id
	FROM	Location C
	WHERE	C.Location_ID = Convert(SmallInt, @ResDOLocID)
                And C.Delete_flag=0
	ORDER BY LocationName
	RETURN @@ROWCOUNT
GO
