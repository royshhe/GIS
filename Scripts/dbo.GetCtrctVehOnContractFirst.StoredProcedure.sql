USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehOnContractFirst]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*  
PURPOSE: To return 1st checked out date for contract
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 26 2000	I don't think this SP is used anymore, but am leaving it
			for the time being.
*/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetCtrctVehOnContractFirst]
	@ContractNum Varchar(10)
AS
	/* 2/19/99 - cpy created - return 1st checked out date for contract */
	DECLARE	@nContractNum Integer
	SELECT	@nContractNum = Convert(Int, NULLIF(@ContractNum,''))

	SELECT 	MIN(Checked_Out)
	FROM	Vehicle_On_Contract
	WHERE	Contract_Number = @nContractNum

	RETURN @@ROWCOUNT















GO
