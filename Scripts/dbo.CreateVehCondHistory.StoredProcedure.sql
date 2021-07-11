USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehCondHistory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehCondHistory    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehCondHistory    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehCondHistory    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehCondHistory    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Condition_History table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehCondHistory]
	@UnitNum Varchar(10),
	@ServiceDate Varchar(24),
	@CondStatus Varchar(1)
AS
DECLARE @iUnitNum Integer
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,""))
	INSERT INTO Condition_History
		(Unit_Number, Condition_Status,
		 Effective_On)
	VALUES	
		(@iUnitNum, NULLIF(@CondStatus,""),
		 Convert(Datetime, NULLIF(@ServiceDate,"")))
	RETURN @iUnitNum













GO
