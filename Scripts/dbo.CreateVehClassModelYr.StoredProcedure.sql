USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehClassModelYr]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To insert a record into Vehicle_Class_Vehicle_Model_Yr table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehClassModelYr]
	@VehModelId   Varchar(5),
	@VehClassCode Varchar(1)
AS
--SET CONCAT_NULL_YIELDS_NULL OFF
	/* 4/28/99 - cpy created - if a record does not exist in vehicle_class_vehicle_model_Yr
				for this @VehClassCode and @VehModelId, create new record */
DECLARE	@iVehModelId SmallInt
	
	SELECT	@iVehModelId = Convert(SmallInt, NULLIF(@VehModelId,'')),
		@VehClassCode = NULLIF(@VehClassCode,'')

	SELECT 	'1'
	FROM	Vehicle_Class_Vehicle_Model_Yr
	WHERE	Vehicle_Model_Id = @iVehModelId
	AND	Vehicle_Class_Code = @VehClassCode

	IF @@ROWCOUNT = 0
		INSERT INTO Vehicle_Class_Vehicle_Model_Yr
			(Vehicle_Model_Id, Vehicle_Class_Code)
		VALUES	(@iVehModelId, @VehClassCode)

	RETURN @iVehModelId













GO
