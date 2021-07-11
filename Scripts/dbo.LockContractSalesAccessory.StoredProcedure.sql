USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockContractSalesAccessory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Contract Sales Accessory for a contract
AUTHOR: Niem Phan
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockContractSalesAccessory]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Contract_Sales_Accessory WITH(UPDLOCK)
	 WHERE	contract_number = @nCtrctNum







GO
