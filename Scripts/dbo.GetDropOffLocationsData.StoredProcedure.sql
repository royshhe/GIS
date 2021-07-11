USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDropOffLocationsData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetDropOffLocationsData    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetDropOffLocationsData    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the rate frop off location for the given parameters.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetDropOffLocationsData]
	@RateID varchar(20), 
	@RateLocationSetID varchar(20)
AS
	/* 10/26/99 - return location ID instead of location name */
	/* 26-nov-99 - order by location name instead of rate_location_set_id */

	SELECT	@RateID = NULLIF(@RateID,''),
		@RateLocationSetID = NULLIF(@RateLocationSetID,'')

	Set Rowcount 2000

	Select	L.Location_Id, 
		L.Location_Id, 
		Convert(char(1), RDOL.Included_In_Rate)
	From
		Location L, 
		Rate_Drop_Off_Location RDOL
	Where
		L.Location_ID = RDOL.Location_Id
	And 	RDOL.Rate_ID = Convert(int, @RateID)
	And 	RDOL.Rate_Location_Set_ID = Convert(int, @RateLocationSetID)
	And 	RDOL.Termination_Date = 'Dec 31 2078 11:59PM'
	And 	L.Delete_Flag = 0
	Order By L.Location

	Return 1
















GO
