USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPSTRate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetPSTRate    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetPSTRate    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetPSTRate]
@VehicleClassCode Varchar(10)
AS
Set Rowcount 1
SELECT
	ISNULL(PST_Rate, 0)
FROM
	Vehicle_Model_Year VMY,
	Vehicle_Class_Vehicle_Model_Yr VCVMY,
	Vehicle_Class VC
WHERE
	VC.Vehicle_Class_Code = @VehicleClassCode
	And VCVMY.Vehicle_Class_Code = VC.Vehicle_Class_Code
	And VMY.Vehicle_Model_ID = VCVMY.Vehicle_Model_ID
RETURN 1












GO
