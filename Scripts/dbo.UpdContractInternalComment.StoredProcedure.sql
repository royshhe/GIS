USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdContractInternalComment]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdContractInternalComment    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdContractInternalComment    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdContractInternalComment    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdContractInternalComment    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Contract_Internal_Comment table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdContractInternalComment]
	@ContractNumber	VarChar(10),
	@Comment	VarChar(255),
	@LoggedOn	VarChar(24),
	@LoggedBy	VarChar(20)
AS
	Declare	@nContractNumber Integer
	Declare	@dLoggedOn DateTime

	Select		@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))
	Select		@dLoggedOn = CONVERT(DateTime, NULLIF(@LoggedOn, ''))

	UPDATE	Contract_Internal_Comment
	SET	Comments	= @Comment,
		Logged_On	= GetDate(),
		Logged_By	= @LoggedBy
	WHERE	Contract_number	= @nContractNumber
	AND		Logged_On		= @dLoggedOn
Return 1














GO
