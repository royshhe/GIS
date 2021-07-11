USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCashAndCCDepositsRefunds]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllCashAndCCDepositsRefunds    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetAllCashAndCCDepositsRefunds    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of cash/credit card deposit/refund for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllCashAndCCDepositsRefunds]
@ContractNum Varchar(10)
AS
SELECT
	Amount
FROM
	Contract_Payment_Item
WHERE
	Contract_Number = Convert(int, @ContractNum)
	And Payment_Type <> 'A/R'
RETURN 1













GO
