USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckContractIsInterBranch]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: CheckContractIsInterBranch
PURPOSE: To check if a contract is interbranch. (Duh!)
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
Don K	Apr 30 1999 Removed checks for drop off & vehicles, just do the opposite
			of IsBudgetBC
*/
CREATE PROCEDURE [dbo].[CheckContractIsInterBranch]
	@ContractNum Varchar(10)
AS
/* This code is the opposite of IsBudgetBC. If you change this,
 * change IsBudgetBC
 */

Declare @PULocID int
Declare @ret int
Select @PULocID =
	(SELECT
		Pick_Up_Location_ID
	FROM
		Contract
	WHERE
		Contract_Number = Convert(int, @ContractNum))
Select
	Location_ID
From
	Location L, Lookup_Table LT
Where
	L.Location_ID = @PULocID
	And L.Owning_Company_ID = Convert(int, LT.Code)
	And LT.Category = 'BudgetBC Company'

If @@ROWCOUNT = 0
	Select @ret = 1
Else
	Select @ret = 0
RETURN @ret

/*
SELECT
	C.Contract_Number
FROM
	Contract C, Location L, Lookup_Table LT
WHERE
	C.Contract_Number = Convert(Int, NULLIF(@ContractNum,""))
	And C.Pick_Up_Location_ID = L.Location_ID
	And LT.Category = 'BudgetBC Company'
	And Convert(int,LT.Code) <> L.Owning_Company_ID
	
	IF @@ROWCOUNT <> 0
		RETURN 1
SELECT
	C.Contract_Number
FROM
	Contract C, Location L, Lookup_Table LT
WHERE
	C.Contract_Number = Convert(Int, NULLIF(@ContractNum,""))
	And C.Drop_Off_Location_ID = L.Location_ID
	And LT.Category = 'BudgetBC Company'
	And Convert(int,LT.Code) <> L.Owning_Company_ID
	
	IF @@ROWCOUNT <> 0
		RETURN 1
SELECT
	VOC.Contract_Number
FROM
	Vehicle_On_Contract VOC, Vehicle V, Lookup_Table LT
WHERE
	VOC.Contract_Number = Convert(Int, NULLIF(@ContractNum,""))
	And VOC.Unit_Number = V.Unit_Number
	And LT.Category = 'BudgetBC Company'
	And Convert(int,LT.Code) <> V.Owning_Company_ID
	
	IF @@ROWCOUNT <> 0
		RETURN 1
RETURN 0
*/

















GO
