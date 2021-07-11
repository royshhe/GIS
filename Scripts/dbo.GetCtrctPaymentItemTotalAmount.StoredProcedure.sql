USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPaymentItemTotalAmount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctPaymentItemTotalAmount    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPaymentItemTotalAmount    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the sum of payment items for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPaymentItemTotalAmount]
@ContractNumber varchar(35)
AS
	/* 3/3/99 - cpy modified - added group by */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

DECLARE	@nContractNumber Integer
SELECT	@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))

SELECT	SUM(Amount)
FROM	Contract_Payment_Item
WHERE	Contract_Number = @nContractNumber
GROUP BY Contract_Number

Return 1

















GO
