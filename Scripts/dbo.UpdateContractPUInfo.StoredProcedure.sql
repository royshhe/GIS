USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContractPUInfo]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To update a record in Contract table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateContractPUInfo]
	@ContractNum Varchar(10),
	@NewPUD      Varchar(24),
	@NewPULocId  Varchar(5)
AS
	/* 4/19/99 - cpy created - update Contract Pick_Up_On and Pick_Up_Loc_Id to match
				   1st VOC record for Contract */

	Declare	@nContractNum Integer
	Select		@nContractNum = Convert(Int, NULLIF(@ContractNum,''))

	UPDATE	Contract
	SET	Pick_Up_On = Convert(Datetime, NULLIF(@NewPUD,'')),
		Pick_Up_Location_ID = Convert(SmallInt, NULLIF(@NewPULocId,''))
	WHERE	Contract_Number = @nContractNum

	RETURN @@ROWCOUNT













GO
