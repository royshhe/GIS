USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateInventoryOption]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateInventoryOption    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateInventoryOption    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateInventoryOption    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateInventoryOption    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Installed_Option table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateInventoryOption]
@UnitNumber varchar(10),@SelectedOption varchar(20)
AS
Insert Into Vehicle_Installed_Option
	(Unit_Number,Vehicle_Option_ID)
Values
	(Convert(int,@UnitNumber),Convert(smallint,@SelectedOption))
Return 1














GO
