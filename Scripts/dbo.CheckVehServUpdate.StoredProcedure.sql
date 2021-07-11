USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehServUpdate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckVehServUpdate    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehServUpdate    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehServUpdate    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehServUpdate    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To retrieve vehicle info for the given unit number..
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckVehServUpdate]
	@UnitNum Varchar(10)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */
DECLARE @iUnitNum Int

	SELECT	@iUnitNum = Convert(Int, NULLIF(@UnitNum,""))

	SELECT	Current_Condition_Status, Current_Km,
		Convert(Char(1), Smoking_Flag)
	FROM	Vehicle
	WHERE	Unit_Number = @iUnitNum
	RETURN @@ROWCOUNT














GO
