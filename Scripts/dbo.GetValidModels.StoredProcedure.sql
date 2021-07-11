USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetValidModels]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetValidModels    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetValidModels    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetValidModels    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetValidModels    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetValidModels]
@ManufacturerID varchar(10),@VehicleType varchar(20),@VehicleClassCode char(1)
AS
Set Rowcount 2000
Select Distinct
	A.Model_Name
From
	Vehicle_Model_Year A,Vehicle_Class_Vehicle_Model_Yr B,
	Vehicle_Class C
Where
	A.Manufacturer_ID=Convert(smallint,@ManufacturerID)
	And A.Vehicle_Model_ID=B.Vehicle_Model_ID
	And B.Vehicle_Class_Code=C.Vehicle_Class_Code
	And C.Vehicle_Class_Code=@VehicleClassCode
	And C.Vehicle_Type_ID=@VehicleType
	
Return 1












GO
