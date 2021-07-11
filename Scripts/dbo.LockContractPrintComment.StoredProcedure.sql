USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockContractPrintComment]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the print comments for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 3 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockContractPrintComment]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	--SELECT	COUNT(*)
	 -- FROM	contract_print_comment --WITH(UPDLOCK)
	 --WHERE	contract_number = @nCtrctNum







GO
