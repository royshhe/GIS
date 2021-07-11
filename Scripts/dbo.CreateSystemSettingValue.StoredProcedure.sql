USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSystemSettingValue]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Service table.
MOD HISTORY:
Name    Date        Comments
 */

create PROCEDURE [dbo].[CreateSystemSettingValue]
	@SettingID Varchar(10),
	@ValueName Varchar(50),
	@SettingValue Varchar(100),
	@Description Varchar(100)
AS
	INSERT INTO SystemSettingValues
		(SettingID,
		 ValueName,
		 SettingValue, 
		 Description)
	VALUES	(
		 Convert(Int, NULLIF(@SettingID,"")),
		 @ValueName,
		 @SettingValue,
		 @Description)
GO
