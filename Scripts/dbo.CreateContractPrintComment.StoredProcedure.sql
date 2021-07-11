USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContractPrintComment]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateContractPrintComment    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractPrintComment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractPrintComment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractPrintComment    Script Date: 11/23/98 3:55:31 PM ******/

/*
PURPOSE: To insert a record into Contract_Print_Comment table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateContractPrintComment]
	@ContractNumber	VarChar(10),
	@CommentID	VarChar(10)
AS
	INSERT INTO Contract_Print_Comment
		(
		Contract_Number,
		Standard_Print_Comment_ID
		)
	VALUES
		(
		CONVERT(Int, @ContractNumber),
		CONVERT(SmallInt, @CommentID)
		)
RETURN 1













GO
