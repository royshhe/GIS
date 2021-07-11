USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockVehicleClass]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the record in vehicle class for the given vehicle class code
AUTHOR: Niem Phan
DATE CREATED: Jan, 13, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockVehicleClass]
	@VehClassCode varchar(1)
AS

	SELECT	COUNT(*)
	  FROM	Vehicle_Class WITH(UPDLOCK)
	 WHERE	Vehicle_Class_Code = @VehClassCode





GO
