USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleModelsByClass]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehicleModelsByClass]
	@VehClassCode	Char(1)
AS
	/* 4/20/99 - cpy created - return all vehicle models for a given vehicle class code
				- only return the most current models defined */

	SET ROWCOUNT 2000
	
	SELECT	@VehClassCode = NULLIF(@VehClassCode,'')

	SELECT	Distinct
		Model_Name,
		Model_Name as ModelName,
		Km_Per_Litre,
		Fuel_Tank_Size,
		PST_Rate,
		Diesel
	FROM	Vehicle_Model_Year VMY1,
		Vehicle_Class_Vehicle_Model_Yr VCVM,
		Vehicle_Class VC
	WHERE	(Model_Year = (	SELECT	MAX(Model_Year)
				FROM	Vehicle_Model_Year VMY2
				WHERE	VMY2.Model_Name = VMY1.Model_Name)
		OR Model_Year IS NULL)
	AND	VC.Vehicle_Class_Code = @VehClassCode
	AND	VC.Vehicle_Class_Code = VCVM.Vehicle_Class_Code
	AND	VCVM.Vehicle_Model_ID = VMY1.Vehicle_Model_ID
	ORDER BY Model_Name

	RETURN @@ROWCOUNT
GO
