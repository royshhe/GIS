USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehServOption]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PROCEDURE NAME: GetVehServOption
PURPOSE: To return vehicle options for vehicle service screen 
AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Vehicle Service
REQUIRES:
ENSURES: 
MOD HISTORY:
Name    Date        Comments
Don K - May 6 1999 - Made @UnitNum match foreign or local unit number
6/07/99 - cpy modified - added current location id and current rental status
CPY - Nov 17 1999 - removed matching on foreign unit number
*/


CREATE PROCEDURE [dbo].[GetVehServOption]
	@UnitNum Varchar(10)
AS

	DECLARE	@nUnitNum int
	-- If IsNumeric(@UnitNum) = 1
	SELECT	@nUnitNum = CAST(NULLIF(@UnitNum,'') AS int)

	SELECT 	Current_Condition_Status,
		Current_Km,
		Convert(Char(1),Smoking_Flag),
		Current_Location_Id,
		Current_Rental_Status
	FROM	Vehicle
	WHERE	Unit_Number = @nUnitNum
	--Or	Foreign_Vehicle_Unit_Number = @UnitNum

  RETURN @@ROWCOUNT
















GO
