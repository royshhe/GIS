USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLvlByLocVehCls]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRateLvlByLocVehCls]
@LocID varchar(10),
@VehClassCode char(1),
@PickupDate varchar(30),
@LocVehRateType varchar(20)

AS

Set Rowcount 2000
	
	/* 3/03/99 - cpy bug fix - added ordering according to rate sel type */

DECLARE @dPickupDate Datetime
DECLARE @sVehType Varchar(18)
DECLARE @nLocID SmallInt
	
SELECT @dPickupDate = Convert(datetime, NULLIF(@PickupDate,""))
SELECT @nLocID = Convert(Smallint, NULLIF(@LocID,""))
SELECT @VehClassCode = NULLIF(@VehClassCode,"")

SELECT @sVehType = (	SELECT
				Vehicle_Type_Id
			FROM
				Vehicle_Class
			WHERE
				Vehicle_Class_Code = @VehClassCode )

SELECT 	Distinct
		LVRL.Rate_ID,
		LVRL.Rate_Level,
		LVRL.Rate_Selection_Type,
		LVC.Vehicle_Class_Code,
		VR.Rate_Name,
		Ordering = CASE LVRL.Rate_Selection_Type
			WHEN 'Rack' THEN 1
			WHEN 'Package' THEN 2
			WHEN 'Promotion' THEN 3
			ELSE 4
		END
FROM	
	Location_Vehicle_Class LVC,
	Location_Vehicle_Rate_Level LVRL,
	Vehicle_Rate VR
WHERE	
		LVC.Location_Vehicle_Class_Id = LVRL.Location_Vehicle_Class_Id
	AND	LVRL.Rate_ID = VR.Rate_ID
	AND	LVC.Location_ID = @nLocID
	AND	LVC.Vehicle_Class_Code = @VehClassCode
	AND	@dPickupDate BETWEEN LVC.Valid_From AND ISNULL(LVC.Valid_To,@dPickupDate)
	AND	@dPickupDate BETWEEN LVRL.Valid_From AND ISNULL(LVRL.Valid_To,@dPickupDate)
	AND	LVRL.Location_Vehicle_Rate_Type = @LocVehRateType
				
UNION -- Union to get all promotions for this location, vehicle type

SELECT 	Distinct
		LVRL.Rate_ID,
		LVRL.Rate_Level,
		LVRL.Rate_Selection_Type,
		LVC.Vehicle_Class_Code,
		VR.Rate_Name,
		Ordering = CASE LVRL.Rate_Selection_Type
			WHEN 'Rack' THEN 1
			WHEN 'Package' THEN 2
			WHEN 'Promotion' THEN 3
			ELSE 4
		END
FROM	
	Location_Vehicle_Class LVC,
	Location_Vehicle_Rate_Level LVRL,
	Vehicle_Class VC,
	Vehicle_Rate VR
WHERE	
		LVC.Location_Vehicle_Class_Id = LVRL.Location_Vehicle_Class_Id
	AND	LVRL.Rate_ID = VR.Rate_ID
	AND	LVC.Location_ID = @nLocID
	AND	VC.Vehicle_Class_Code = LVC.Vehicle_Class_Code
	AND	VC.Vehicle_Type_Id = @sVehType
	AND	@dPickupDate BETWEEN LVC.Valid_From AND ISNULL(LVC.Valid_To,@dPickupDate)
	AND	@dPickupDate BETWEEN LVRL.Valid_From AND ISNULL(LVRL.Valid_To,@dPickupDate)
	AND	LVRL.Rate_Selection_Type = 'Promotion'
        AND	LVRL.Location_Vehicle_Rate_Type = @LocVehRateType

ORDER BY Ordering, LVRL.Rate_ID desc


RETURN @@ROWCOUNT
GO
