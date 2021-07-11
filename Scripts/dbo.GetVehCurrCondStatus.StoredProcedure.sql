USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehCurrCondStatus]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehCurrCondStatus    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetVehCurrCondStatus    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehCurrCondStatus    Script Date: 1/11/99 1:03:17 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehCurrCondStatus]
	@UnitNum Varchar(10)
AS
	SET ROWCOUNT 1
	DECLARE	@nUnitNum Integer
	SELECT	@nUnitNum = Convert(Int, NULLIF(@UnitNum, ""))

	SELECT 	Current_Condition_Status,
		Condition_Status_Effective_On

	FROM	Vehicle
	WHERE	Unit_Number = @nUnitNum
	RETURN @@ROWCOUNT













GO
