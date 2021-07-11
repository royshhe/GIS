USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintInterimBillData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  PURPOSE:		To retrieve the interimbill information for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintInterimBillData] -- 1722772
	@ContractNumber varchar(35)
AS
	/* 2/25/99 - cpy created - get interim bill data with address */

DECLARE 	@RBRDate datetime 
DECLARE		@GST	 decimal(7, 2)
DECLARE		@PST	 decimal(7, 2)

SELECT	@RBRDate	= getdate()
	
 
	SELECT 	 @GST=Tax_Rate/100
	--select *
	FROM		Tax_Rate
	WHERE	@RBRDate BETWEEN Valid_From AND Valid_To and TAX_Type='GST'
	SELECT 	 @PST=Tax_Rate/100
	FROM		Tax_Rate
	WHERE	@RBRDate BETWEEN Valid_From AND Valid_To and TAX_Type='PST'


	SET Rowcount 2000

	SELECT	IB.Interim_Bill_Date,
		IB.Amount,
		IB.Current_Km,
		ARM.Address_Name,
		L.Location,
       convert(decimal(9,2),(((IB.Amount-isnull(IB.Coverage_Amount,0)-isnull(IB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))*@GST
			+ isnull(IB.Coverage_Amount,0)*@GST)) as GSTAmount,
       convert(decimal(9,2),((IB.Amount-isnull(IB.Coverage_Amount,0)-isnull(IB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))*@PST) as PSTAmount,
	   rtrim(convert(varchar,ARE.Contract_Number)) + '-' +
				RIGHT(CONVERT(varchar, 
				ARE.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber
       --Tot.TotalAmount,
	FROM
--		Contract_Payment_Item CPI
--		INNER JOIN AR_Payment AR
--		  ON CPI.Contract_Number = AR.Contract_Number
--		 And CPI.Sequence = AR.Sequence
--		
--		 
--		 Inner JOIN         
--			(	   SELECT Contract_Number, SUM(Amount+GST_Amount+PST_Amount+PVRT_Amount) AS TotalAmount,
--						  SUM(GST_Amount + GST_Amount_Included)/SUM(Amount-GST_Amount_Included - PST_Amount_Included) GSTRate,
--						  Sum(PST_Amount+  PST_Amount_Included)/SUM(Amount-GST_Amount_Included - PST_Amount_Included) PSTRate,
--						  SUM(GST_Amount + GST_Amount_Included) GSTAmount,
--						  Sum(PST_Amount+  PST_Amount_Included) PSTAmount
--				FROM   (SELECT Contract_Number, Amount,GST_Amount,PST_Amount,PVRT_Amount,GST_Amount_Included,  PST_Amount_Included
--								FROM   dbo.Contract_Charge_Item AS cci
--								UNION ALL
--								SELECT Contract_Number, Flat_Amount * - 1 AS Amount,0 GST_Amount,0 PST_Amount,0 PVRT_Amount, 0 GST_Amount_Included, 0 PST_Amount_Included
--								FROM  dbo.Contract_Reimbur_and_Discount AS cci
--						) AS Con
--										 
--				 
--				Group by  Contract_Number
--			  ) AS Tot ON AR.Contract_Number = Tot.Contract_Number

	
		  (select contract_number,
					interim_bill_date,
					business_transaction_id,
					contract_billing_party_id,
					sum(amount) as Amount,
					max(isnull(Current_KM,0)) as Current_KM,
					sum(isnull(Coverage_amount,0)) as Coverage_amount
			from Interim_Bill_vw
			group by contract_number,
						interim_bill_date,
						business_transaction_id,
						contract_billing_party_id) IB

		JOIN Contract_Billing_Party CBP
		  ON IB.Contract_Number = CBP.Contract_Number
		 And IB.Contract_Billing_Party_Id = CBP.Contract_Billing_Party_Id

		JOIN armaster ARM
		  ON CBP.Customer_Code = ARM.Customer_Code
		 AND ARM.Address_Type = 0	
	 	  
	Left JOIN dbo.AR_Export ARE 
		ON IB.Contract_Number = ARE.Contract_Number 
		AND IB.Business_Transaction_ID = ARE.ITB_BU_ID  

	Left JOIN Location L
		  ON ARE.Location_Id = L.Location_Id


	WHERE
		IB.Contract_Number = Convert(int,@ContractNumber)

	RETURN @@ROWCOUNT

GO
