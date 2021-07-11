USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchVehicleClassData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSearchVehicleClassData    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchVehicleClassData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchVehicleClassData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchVehicleClassData    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetSearchVehicleClassData]
@ClassCode char(1),@ClassName varchar(35),@ClassType varchar(35)
AS
Set Rowcount 2000
Select Distinct
	Vehicle_Class_Code,Vehicle_Class_Name,Vehicle_Type_ID
From
	Vehicle_Class
Where
	Vehicle_Class_Code Like (LTrim(@ClassCode) + "%")
	And Vehicle_Class_Name Like (LTrim(@ClassName) + "%")
	And Vehicle_Type_ID Like (LTrim(@ClassType) + "%")
Order By Vehicle_Class_Code
Return 1












GO
