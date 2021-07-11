USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehModelNameExists]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To check whether or not a vehicle model name @ModelName is attached to 
	 any other GIS vehicle class code other than @VehClassCode
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 4 2000	Created
*/
CREATE PROCEDURE [dbo].[CheckVehModelNameExists]
	@ModelName	Varchar(30),
	@VehClassCode	Varchar(1)
AS
	SELECT	@ModelName = NULLIF(@ModelName,'')

	SELECT	VMY.Vehicle_Model_ID, 
		VMY.Model_Name, 
		VMY.Model_Year, 
		VCVMY.Vehicle_Class_Code, 
		VC.Vehicle_Class_Name,
		VMY.Foreign_Model_Only
	FROM	Vehicle_Model_Year VMY
		LEFT OUTER JOIN	
			Vehicle_Class_Vehicle_Model_Yr VCVMY
			JOIN Vehicle_Class VC
			  ON VCVMY.Vehicle_Class_Code = VC.Vehicle_Class_Code
		ON VMY.Vehicle_Model_Id = VCVMY.Vehicle_Model_Id
	WHERE	VMY.Model_Name = @ModelName
	AND	ISNULL(VMY.Model_Year, 0) = ISNULL(	(	SELECT	MAX(Model_Year)
								FROM	Vehicle_Model_Year
								WHERE	Model_Name = @ModelName
				  			), 0
						)
	AND	VCVMY.Vehicle_Class_Code <> @VehClassCode

	RETURN @@ROWCOUNT






GO
