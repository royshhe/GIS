USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckContractIsForeign]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckContractIsForeign    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CheckContractIsForeign    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckContractIsForeign    Script Date: 1/11/99 1:03:13 PM ******/
/*
PURPOSE: To Return 1 if the contract record contains foreign contract number, else return 0.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckContractIsForeign]
	@ContractNum Varchar(10)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = Convert(Int, NULLIF(@ContractNum,""))

	SELECT	Foreign_Contract_Number
	FROM	Contract
	WHERE	Contract_Number = @iCtrctNum
	AND	NULLIF(Foreign_Contract_Number,"") IS NOT NULL
	IF @@ROWCOUNT = 0
		RETURN 0
	ELSE
		RETURN 1





GO
