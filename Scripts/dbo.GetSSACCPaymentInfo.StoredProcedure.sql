USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSSACCPaymentInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Retrieve CC transaction details for a separate sales accessory 
MOD HISTORY:
Name	Date		Comment
CPY 	6/22/99 	- added Trx columns
CPY	6/23/99 	- added join to Sales_Accessory_Sale_Payment to get the
			transaction type, amount, date, time 
CPY	9/27/99 	- do type conversion outside of select
CPY	Dec 17 1999	- changed transaction desc from 'Deposit' to 'Purchase'
CPY	Dec 22 1999	- changed transaction desc from 'Refund' to 'Return'
CPY	Jan 10 2000	Changed swiped flag field to return 'M' or 'S' depending on 
			whether transaction was processed via Eigen
ROY HE MAR 25 2011 MSSQL 2008 UPGRADE
*/
CREATE PROCEDURE [dbo].[GetSSACCPaymentInfo] --29949
	@SalesContractNum Varchar(11)
AS
DECLARE @iSalesCtrctNum Int

SELECT @iSalesCtrctNum = CONVERT(int, NULLIF(@SalesContractNum,''))

SELECT
	CC.Credit_Card_Type_ID,
	CC.Credit_Card_Number,
	CC.Short_Token,
	CC.Last_Name,
	CC.First_Name,
	CC.Expiry,
	SASCCP.Authorization_Number,
	CASE
		-- suppress M/S if not processed via Eigen; if no terminal id, 
		-- then the CC transaction was not processed via Eigen
		WHEN SASCCP.Terminal_Id IS NULL THEN ''  
		WHEN SASCCP.Swiped_Flag = 0 THEN 'M'
		WHEN SASCCP.Swiped_Flag = 1 THEN 'S'
		ELSE ''	-- default
	END, --Convert(Char(1),SASCCP.Swiped_Flag),
	SASCCP.Terminal_ID,
	SASCCP.Trx_Receipt_Ref_Num,
	SASCCP.Trx_ISO_Response_Code,
	SASCCP.Trx_Remarks,
	CASE
		WHEN SASP.Amount < 0 THEN 'Return' 	-- aka 'Refund'
		ELSE 'Purchase'				-- aka 'Deposit'
	END,
	ABS(SASP.Amount),
	Convert(Char(20), SASP.Collected_On, 113)
FROM
	Sales_Accessory_CrCard_Payment SASCCP
	INNER JOIN	Credit_Card CC
	ON 	SASCCP.Credit_Card_Key = CC.Credit_Card_Key
	LEFT JOIN Sales_Accessory_Sale_Payment SASP
	ON SASCCP.Sales_Contract_Number = SASP.Sales_Contract_Number
WHERE
	SASCCP.Sales_Contract_Number = @iSalesCtrctNum
--AND	SASCCP.Sales_Contract_Number *= SASP.Sales_Contract_Number
--And 	SASCCP.Credit_Card_Key = CC.Credit_Card_Key
--	
RETURN @@ROWCOUNT


--SELECT  * FROM Sales_Accessory_CrCard_Payment
GO
