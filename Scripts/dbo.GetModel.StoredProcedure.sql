USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetModel]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetModel    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetModel    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetModel    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetModel    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetModel]
	@VehicleClassCode	VarChar(1)
AS
   	Set Rowcount 2000
	
   	SELECT	Distinct VMY.Model_Name
   	FROM   	Vehicle_Class_Vehicle_Model_Yr VCVMY,
			Vehicle_Model_Year VMY
	WHERE	VCVMY.Vehicle_Class_Code = @VehicleClassCode
	AND		VCVMY.Vehicle_Model_ID = VMY.Vehicle_Model_ID
   	ORDER BY 	
		VMY.Model_Name
   	RETURN 1













GO
