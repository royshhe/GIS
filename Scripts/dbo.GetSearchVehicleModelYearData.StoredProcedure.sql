USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchVehicleModelYearData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSearchVehicleModelYearData    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchVehicleModelYearData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchVehicleModelYearData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchVehicleModelYearData    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetSearchVehicleModelYearData]
@Model varchar(255),
@Year varchar(4),
@Class varchar(255)
AS
Set Rowcount 2000
Select	DISTINCT
	VMY.Vehicle_Model_ID,
	VMY.Model_Name,
	VMY.Model_Year,
	VC.Vehicle_Class_Name,
	Case
		When VMY.Manufacturer_Id Is Null Then
			''
		Else
			LT.Value
	End
From
	Vehicle_Model_Year VMY,
	Vehicle_Class VC,
	Lookup_Table LT,
	Vehicle_Class_Vehicle_Model_Yr VCVMY
Where
	VMY.Model_Name Like (LTrim(@Model) + "%")
	And ISNULL(Convert(varchar(255), VMY.Model_Year), '') Like LTrim(@Year) + "%"
	And VC.Vehicle_Class_Name Like LTrim(@Class) + "%"
	And VMY.Vehicle_Model_ID = VCVMY.Vehicle_Model_ID
	And VCVMY.Vehicle_Class_Code = VC.Vehicle_Class_Code
	
	And (	LT.Category = 'Manufacturer' And LT.Code = Convert(varchar,VMY.Manufacturer_ID)
		Or
		VMY.Manufacturer_ID Is Null
	    )
Order By Model_Name, Model_Year Desc
Return 1












GO
