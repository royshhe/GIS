USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteVehicleClass]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteVehicleClass    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleClass    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleClass    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleClass    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Optional_Extra_Restriction, LDW_Deductible and Vehicle_Class table.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteVehicleClass]
@VehicleClassCode char(1)
AS

Delete From Optional_Extra_Restriction
Where
	Vehicle_Class_Code=@VehicleClassCode

Delete From LDW_Deductible
Where
	Vehicle_Class_Code=@VehicleClassCode

Delete From Vehicle_Class
Where
	Vehicle_Class_Code=@VehicleClassCode
Return 1













GO
