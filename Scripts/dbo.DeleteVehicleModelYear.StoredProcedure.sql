USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteVehicleModelYear]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteVehicleModelYear    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleModelYear    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleModelYear    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleModelYear    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Vehicle_Class_Vehicle_Model_Yr and Vehicle_Model_Year table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteVehicleModelYear]
@Vehicle_Model_ID varchar(35)
AS

Delete From Vehicle_Class_Vehicle_Model_Yr
Where
	Vehicle_Model_ID=Convert(smallint,@Vehicle_Model_ID)

Delete From Vehicle_Model_Year
Where
	Vehicle_Model_ID=Convert(smallint,@Vehicle_Model_ID)

Return 1














GO
