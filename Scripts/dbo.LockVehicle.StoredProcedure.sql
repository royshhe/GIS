USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockVehicle]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the vehicle record for the given unit number
AUTHOR: Niem Phan
DATE CREATED: Jan 14, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockVehicle]
	@UnitNumber varchar(11)
AS

	DECLARE	@iUnitNumber Integer
	SELECT 	@iUnitNumber = CAST(NULLIF(@UnitNumber, '') AS Integer)

	SELECT	COUNT(*)
	  FROM	Vehicle WITH(UPDLOCK)
	 WHERE	Unit_Number = @iUnitNumber






GO
