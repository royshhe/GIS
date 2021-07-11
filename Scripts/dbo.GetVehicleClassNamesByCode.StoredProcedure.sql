USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleClassNamesByCode]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehicleClassNamesByCode    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleClassNamesByCode    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[GetVehicleClassNamesByCode]
	@VehicleClassCode VarChar(1)
AS
Select	DISTINCT
	Vehicle_Class_Name
From
	Vehicle_Class
Where	Vehicle_Class_Code = @VehicleClassCode
Return 1












GO
