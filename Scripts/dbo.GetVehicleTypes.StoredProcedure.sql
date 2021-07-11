USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleTypes]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehicleTypes    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleTypes    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleTypes    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleTypes    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehicleTypes]
AS
Set Rowcount 2000
Select Distinct
	Vehicle_Type_ID
From
	Vehicle_Type
Return 1












GO
