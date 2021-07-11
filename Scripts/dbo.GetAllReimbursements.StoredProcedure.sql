USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllReimbursements]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllReimbursements    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.GetAllReimbursements    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of reimbursement for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllReimbursements]
@ContractNum Varchar(10)
AS
Set Rowcount 2000
SELECT
	ISNULL(Flat_Amount, 0), Reimbursement_Reason
FROM
	Contract_Reimbur_And_Discount
WHERE
	Contract_Number = Convert(int, @ContractNum)
	And Type = 'Reimbursement'
RETURN 1













GO
