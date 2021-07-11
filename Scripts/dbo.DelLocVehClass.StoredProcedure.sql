USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelLocVehClass]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelLocVehClass    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.DelLocVehClass    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelLocVehClass    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelLocVehClass    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Location_Vehicle_Class table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DelLocVehClass]
	@LocationVehicleClassID	VarChar(10)
AS
	
   	Delete	Location_Vehicle_Class
	WHERE	Location_Vehicle_Class_ID = CONVERT(SmallInt, @LocationVehicleClassID)
   	RETURN 1













GO
