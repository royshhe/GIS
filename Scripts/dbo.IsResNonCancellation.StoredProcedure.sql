USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsResNonCancellation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To - 
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[IsResNonCancellation]  -- '26','N', '2013-07-30' 
	@LocId 		Varchar(5),
	@VehClassCode 	Varchar(1),
	@PUDate	Varchar(11)
	
AS
DECLARE @iLocId SmallInt,
	@dPUDate Datetime, 	 
	@iExist SmallInt

	SELECT 	@iLocId = Convert(SmallInt, NULLIF(@LocId,"")),
		@VehClassCode = NULLIF(@VehClassCode,""),
		@dPUDate = Convert(Datetime, NULLIF(@PUDate,"")) 
	 
	SELECT	 Count(*) as NonCacellation
	--select *
	FROM	Reservation_Non_Cancellation_Period
	WHERE	Location_Id = @iLocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	@dPUDate BETWEEN Valid_from AND Valid_to
 
		
 













GO
