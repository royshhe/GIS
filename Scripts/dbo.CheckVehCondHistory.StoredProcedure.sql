USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehCondHistory]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckVehCondHistory    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehCondHistory    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehCondHistory    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehCondHistory    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To retrieve condition history info for the given unit number.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckVehCondHistory]
	@UnitNum Varchar(10)
AS
	/* 10/21/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iUnitNum Int
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,''))

	SET ROWCOUNT 1
	SELECT	Unit_Number, Effective_On, Condition_Status
	FROM	Condition_History
	WHERE	Unit_Number = @iUnitNum
	ORDER BY Effective_On DESC
	RETURN @@ROWCOUNT














GO
