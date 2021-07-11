USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContractPrintComment]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To update a record in Contract_Print_Comment table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateContractPrintComment]
	@ContractNumber	VarChar(10),
	@OldCommentId Varchar(5),
	@NewCommentId Varchar(5)
AS
	/* 3/08/99 - cpy created for CO bug fix #96 */
	Declare	@nContractNumber Integer
	Declare	@nOldCommentId SmallInt
	
	Select		@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber,''))
	Select		@nOldCommentId = Convert(SmallInt, NullIf(@OldCommentId,''))
	
	UPDATE	Contract_Print_Comment
	SET	Standard_Print_Comment_Id = Convert(SmallInt, NullIf(@NewCommentId,''))
	WHERE	Contract_number	= @nContractNumber
	AND	Standard_Print_Comment_Id = @nOldCommentId

	RETURN 1















GO
