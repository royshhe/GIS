USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsBudgetBCContract]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.IsBudgetBCContract    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.IsBudgetBCContract    Script Date: 2/16/99 2:05:43 PM ******/
/*
PURPOSE: To check if the given contract number is BudgetBC contract. If so return 1and 0 otherwise.
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[IsBudgetBCContract]
@ContractNum	VarChar(10)
AS
/* This code is the opposite of CheckContractIsInterbranch. If you change this,
 * change CheckContractIsInterbranch
 */
Declare @PULocID int
Declare @ret int
Declare @nContractNum Integer
Select @nContractNum = Convert(int, NULLIF(@ContractNum, ''))

Select @PULocID =
	(SELECT
		Pick_Up_Location_ID
	FROM
		Contract
	WHERE
		Contract_Number = @nContractNum)
Select
	Location_ID
From
	Location L, Lookup_Table LT
Where
	L.Location_ID = @PULocID
	And L.Owning_Company_ID = Convert(int, LT.Code)
	And LT.Category = 'BudgetBC Company'
If @@ROWCOUNT = 0
	Select @ret = 0
Else
	Select @ret = 1
RETURN @ret















GO
