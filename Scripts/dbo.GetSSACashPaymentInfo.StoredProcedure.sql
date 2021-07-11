USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSSACashPaymentInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetSSACashPaymentInfo    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetSSACashPaymentInfo    Script Date: 2/16/99 2:05:42 PM ******/

CREATE PROCEDURE [dbo].[GetSSACashPaymentInfo] -- '29925'
@SalesContractNum Varchar(11)
AS
	/* 9/27/99 - do type conversion outside of select */
	/* 2011/03/25 MSSQL 2008 UPGRADE*/
DECLARE @iSalesCtrctNum Int

	SELECT @iSalesCtrctNum = CONVERT(int, NULLIF(@SalesContractNum,''))

SELECT
	LT.Value AS  Cash_Payment_Type,
	Foreign_Money_Collected,
	Currency_ID,
	Exchange_Rate,
	dbo.ccmask(Identification_Number,4,4),
	Authorization_Number,
	CASE
		WHEN CP.Swiped_Flag = 0 THEN 'M'
		WHEN CP.Swiped_Flag = 1 THEN 'S'
	END, --Convert(Char(1),CP.Swiped_Flag),
	CP.Terminal_ID,
	CP.Trx_Receipt_Ref_Num,
	CP.Trx_ISO_Response_Code,
	CP.Trx_Remarks,
	CASE
		WHEN SASP.Amount < 0 THEN 'Return' 	-- aka 'Refund'
		ELSE 'Purchase'				-- aka 'Deposit'
	END,
	ABS(SASP.Amount),
	Convert(Char(20), SASP.Collected_On, 113)
--select *
FROM
	Sales_Accessory_Cash_Payment CP
INNER JOIN Lookup_Table LT
	ON LT.Code = CP.Cash_Payment_Type
LEFT JOIN 	Sales_Accessory_Sale_Payment SASP
	ON CP.Sales_Contract_Number = SASP.Sales_Contract_Number
	
WHERE
	CP.Sales_Contract_Number = @iSalesCtrctNum
--	AND	CP.Sales_Contract_Number *= SASP.Sales_Contract_Number
	AND	LT.Category IN ('Cash Payment Method','Cash Refund Method')
--	AND	LT.Code = CP.Cash_Payment_Type
--	
RETURN @@ROWCOUNT

--SELECT * FROM Sales_Accessory_Cash_Payment WHERE Sales_Contract_Number NOT IN (SELECT Sales_Contract_Number FROM Sales_Accessory_Sale_Payment)
GO
