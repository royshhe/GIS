USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVSIDoNotSwitchVehFlagCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Count the number of support incidents on a contract that didn't 
  require a vehicle switch.
MOD HISTORY:
Name	Date		Comment
	Oct 29 - Moved data conversion code out of the where clause 
*/
CREATE PROCEDURE [dbo].[GetVSIDoNotSwitchVehFlagCount]
	@ContractNumber			VarChar(10),
	@Sequence			VarChar(10)
AS
	/* 5/02/99 - cpy bug fix - added Do_Not_Switch_Vehicle = 1 */
	Declare	@nContractNumber Integer
	Declare	@nSequence Integer
	
	Select		@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))
	Select		@nSequence = CONVERT(Int, NULLIF(@Sequence, ''))

	SELECT	Count(*)
	FROM	Vehicle_Support_Incident

	WHERE	Contract_Number	= @nContractNumber
	AND	Vehicle_Support_Incident_Seq <> @nSequence
	AND	Do_Not_Switch_Vehicle = 1

	Return 1
















GO
