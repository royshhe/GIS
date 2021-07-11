USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateChargeGL]    Script Date: 2021-07-10 1:50:47 PM ******/
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

create PROCEDURE [dbo].[CreateChargeGL]
	@Charge_Type_ID Varchar(10),
	@Vehicle_Type_ID Varchar(18),
	@GL_Account Varchar(32)
AS
	INSERT INTO Charge_GL
		(Charge_Type_ID,
		 Vehicle_Type_ID,
		 GL_Revenue_Account)
	VALUES	(
		 Convert(Int, NULLIF(@Charge_Type_ID,"")),
		 @Vehicle_Type_ID,
		 @GL_Account
			)
	RETURN 1
GO
