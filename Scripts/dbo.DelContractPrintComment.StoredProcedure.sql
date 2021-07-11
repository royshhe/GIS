USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelContractPrintComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelContractPrintComment    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.DelContractPrintComment    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelContractPrintComment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelContractPrintComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Contract_Print_Comment table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[DelContractPrintComment]
	@ContractNumber	VarChar(10),
	@CommentID	VarChar(10)
AS
	DELETE	Contract_Print_Comment
	WHERE	Contract_number	= CONVERT(Int, @ContractNumber)
	AND	Standard_Print_Comment_ID = CONVERT(SmallInt, @CommentID)
Return 1













GO
