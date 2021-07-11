USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IB_CreateAcctgTrans]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: 
REQUIRES: 
AUTHOR: Roy He
DATE CREATED: Sep 14, 2006
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[IB_CreateAcctgTrans]
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS


DECLARE 	@startDate datetime,
		@endDate datetime		

SELECT	@startDate	= CONVERT(datetime, NULLIF(@paramStartDate,'')),
	@endDate	= CONVERT(datetime, NULLIF(@paramEndDate,''))	
	
	
	



	--Generate Interbrantch Detail Records
    Delete IB_ARAP_Detail Where rbr_date Between @startDate and @endDate 

	Insert into IB_ARAP_Detail ( RBR_Date, Contract_number, Revenue_Account, Amount, Commission_Rate, Vehicle_Ownership_Vendor_Code, Vehicle_Ownership_Customer_code, 
                      Renting_Compay_Vendor_Code, Renting_Compay_Customer_Code, Receiving_Company_Vendor_Code, Receiving_Company_Customer_Code, Subleger, 
                      Customer_Type, Vendor_Type, Customer_code, Vendor_code,IB_Zone, Contract_Currency_ID
	)  select *  from dbo.IB_ARAP_Detail_vw
	Where rbr_date Between @startDate and @endDate

 

       -- Interbrantch Ar Transaction

        Delete IB_AR_Detail FROM  dbo.IB_AR_Detail 
	INNER JOIN
        dbo.IB_AR_Header 
		ON dbo.IB_AR_Detail.IB_AR_ID = dbo.IB_AR_Header.IB_AR_ID Where dbo.IB_AR_Header.rbr_date Between @startDate and @endDate


	Delete IB_AR_Header  Where rbr_date Between @startDate and @endDate


	

       /* Insert records into IB_AR_Header table */  
         



        INSERT
          INTO  IB_AR_Header
                (
		contract_number,                               
		rbr_date,
		customer_account,
		amount,               
		doc_ctrl_num_base,
		doc_ctrl_num_type
                )
        SELECT       
		Contract_number, 
		RBR_Date, 
		Customer_code, 
		sum(Amount) Amount,
		'C' + RIGHT(CONVERT(varchar, contract_number + 10000000000), 10) +  'I' doc_ctrl_num_base,  
		NULL  doc_ctrl_num_type
FROM         dbo.IB_ARAP_Detail
where Subleger='AR' AND Amount<>0 and dbo.IB_ARAP_Detail.RBR_Date Between @startDate and @endDate
group by  RBR_Date, Customer_code,  Contract_number
HAVING sum(Amount)<>0
--Select * from IB_AR_Header where contract_number=1910119

--select * from   dbo.IB_ARAP_Detail where contract_number=1910119 and subleger='ar'


/* Determine the type of records (Invoice or Adjustment) 
 * Make the first record an invoice and all others adjustments
 * when sorted by transaction date and ar_export_id
 */
        UPDATE  IB_AR_Header
           SET  doc_ctrl_num_type = 'I'
         WHERE  doc_ctrl_num_type IS NULL
	   AND	rbr_date = 
		(
		SELECT	MIN(ar2.rbr_date)
		  FROM	IB_AR_Header ar2
		 WHERE	ar2.doc_ctrl_num_base = IB_AR_Header.doc_ctrl_num_base
		   AND	ar2.customer_account = IB_AR_Header.customer_account
		)
	  
	   AND	NOT EXISTS
		(
                /* eliminate new transactions that are adjustments
		 * of existing invoices.
		 */
		SELECT	*
		  FROM	IB_AR_Header arExists
		 WHERE	arExists.doc_ctrl_num_type = 'I'
		   AND	arExists.doc_ctrl_num_base = IB_AR_Header.doc_ctrl_num_base
		   AND	arExists.customer_account = IB_AR_Header.customer_account
		)

        /* set remaining transactions to be adjustments */
        UPDATE  IB_AR_Header
           SET  doc_ctrl_num_type = 'A'
         WHERE  doc_ctrl_num_type IS NULL


/* Set sequence numbers
 * Use two correlated subqueries. The first calculates the maximum existing 
 * sequence number and the second calculates the record's position within the 
 * new records for this base.
 */
	UPDATE	IB_AR_Header
	   SET	doc_ctrl_num_seq =
		(
		SELECT	existing.max_seq + new.position
		  FROM	(
			SELECT	ISNULL(MAX(doc_ctrl_num_seq), 0) max_seq
			  FROM	IB_AR_Header ar2
			 WHERE	ar2.doc_ctrl_num_base =	IB_AR_Header.doc_ctrl_num_base
			   AND	ar2.doc_ctrl_num_type =	IB_AR_Header.doc_ctrl_num_type
			) existing,
			(
			SELECT	COUNT(*) + 1 position
			  FROM	IB_AR_Header ar3
			 WHERE	ar3.doc_ctrl_num_seq IS	NULL
			   AND	ar3.doc_ctrl_num_base =	IB_AR_Header.doc_ctrl_num_base
			   AND	ar3.doc_ctrl_num_type =	IB_AR_Header.doc_ctrl_num_type
			   AND	ar3.IB_AR_ID < IB_AR_Header.IB_AR_ID			  
			) new
		)
	 WHERE  doc_ctrl_num_seq IS NULL
/* Link adjustments to original invoices */
        UPDATE  IB_AR_Header
           SET  apply_to_doc_ctrl_num =
                        (
                        SELECT  IB_AR_Header.doc_ctrl_num_base + 'I' +
                                  RIGHT(CONVERT(varchar,
                                  MAX(ar2.doc_ctrl_num_seq) +
                                  1000), 3)
                          FROM  IB_AR_Header ar2
                         WHERE  ar2.doc_ctrl_num_base =
                                  IB_AR_Header.doc_ctrl_num_base
                           AND  ar2.customer_account = IB_AR_Header.customer_account

                           AND  ar2.doc_ctrl_num_type = 'I'
                        )
         WHERE  doc_ctrl_num_type = 'A'
           AND  apply_to_doc_ctrl_num IS NULL


--select * from IB_ARAP_Detail
-- Detail

INSERT INTO 
	IB_AR_Detail (
	IB_AR_ID ,
	Revenue_Account,
	Amount
) 

SELECT  dbo.IB_AR_Header.IB_AR_ID, 
	dbo.IB_ARAP_Detail.Revenue_Account, 
	SUM(dbo.IB_ARAP_Detail.Amount) AS Amount
FROM    dbo.IB_ARAP_Detail INNER JOIN
                      dbo.IB_AR_Header ON dbo.IB_ARAP_Detail.Contract_number = dbo.IB_AR_Header.Contract_Number AND 
                      dbo.IB_ARAP_Detail.RBR_Date = dbo.IB_AR_Header.RBR_Date AND 
                      dbo.IB_ARAP_Detail.Customer_code = dbo.IB_AR_Header.Customer_Account
where dbo.IB_ARAP_Detail.Amount<>0 and dbo.IB_AR_Header.RBR_Date Between @startDate and @endDate
GROUP BY dbo.IB_AR_Header.IB_AR_ID, dbo.IB_ARAP_Detail.Revenue_Account
Having SUM(dbo.IB_ARAP_Detail.Amount)<>0

INSERT INTO 
	IB_AR_Detail (
	IB_AR_ID ,
	Revenue_Account,
	Amount
) 

SELECT     dbo.IB_AR_Header.IB_AR_ID, 
ARCust.AR_Interbranch_CAN_Account, 
CONVERT(DECIMAL(9,2), SUM(CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Amount) * CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Commission_Rate)))* (- 1.00) AS Amount
FROM         dbo.IB_ARAP_Detail  INNER JOIN
                      dbo.IB_ARCust_APVend_vw ARCust ON IB_ARAP_Detail.Customer_code = ARCust.Customer_code INNER JOIN
                      dbo.IB_AR_Header ON IB_ARAP_Detail.Contract_number = dbo.IB_AR_Header.Contract_Number AND 
                      IB_ARAP_Detail.RBR_Date = dbo.IB_AR_Header.RBR_Date AND IB_ARAP_Detail.Customer_code = dbo.IB_AR_Header.Customer_Account
WHERE     (IB_ARAP_Detail.Subleger = 'AR') AND IB_ARAP_Detail.Amount<>0 and dbo.IB_AR_Header.RBR_Date Between @startDate and @endDate
GROUP BY dbo.IB_AR_Header.IB_AR_ID, ARCust.AR_Interbranch_CAN_Account
HAVING sum(dbo.IB_ARAP_Detail.Amount*dbo.IB_ARAP_Detail.Commission_Rate)<>0



INSERT INTO 
	IB_AR_Detail (
	IB_AR_ID ,
	Revenue_Account,
	Amount
) 
SELECT     
	dbo.IB_AR_Header.IB_AR_ID, 
	TaxRate.Payables_Clearing_Account, 
	CONVERT(DECIMAL(9,2), 
		SUM(CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Amount) * CONVERT(DECIMAL(11,4), 1.00-IB_ARAP_Detail.Commission_Rate))*TaxRate.Tax_Rate/100
	) AS Amount
FROM         dbo.IB_ARAP_Detail  INNER JOIN
                      dbo.IB_ARCust_APVend_vw ARCust ON IB_ARAP_Detail.Customer_code = ARCust.Customer_code INNER JOIN
                      dbo.IB_AR_Header ON IB_ARAP_Detail.Contract_number = dbo.IB_AR_Header.Contract_Number AND 
                      IB_ARAP_Detail.RBR_Date = dbo.IB_AR_Header.RBR_Date AND IB_ARAP_Detail.Customer_code = dbo.IB_AR_Header.Customer_Account
          Inner Join   
          
          (
           SELECT  Valid_From, Valid_To, Tax_Type, Tax_Rate, Rate_Type, Last_Changed_By, Last_Changed_On, Payables_Clearing_Account
				FROM  Tax_Rate
		   WHERE (Tax_Type IN ('HST', 'GST')) 
		   ) TaxRate  on IB_ARAP_Detail.RBR_Date >=TaxRate.Valid_from and IB_ARAP_Detail.RBR_Date<=TaxRate.Valid_To
  
            
WHERE     (IB_ARAP_Detail.Subleger = 'AR') AND IB_ARAP_Detail.Amount<>0 and dbo.IB_AR_Header.RBR_Date Between @startDate and @endDate
		  And IB_ARAP_Detail.IB_Zone<>'US'
          --And IB_ARAP_Detail.Contract_Currency_ID=1
--and IB_ARAP_Detail.contract_number=1910119
GROUP BY dbo.IB_AR_Header.IB_AR_ID, ARCust.AR_Interbranch_CAN_Account,TaxRate.Payables_Clearing_Account,TaxRate.Tax_Rate
--HAVING sum(dbo.IB_ARAP_Detail.Amount*dbo.IB_ARAP_Detail.Commission_Rate)<>0







-- Interbrantch AP Transaction

Delete IB_AP_Detail FROM  dbo.IB_AP_Detail 
	INNER JOIN
        dbo.IB_AP_Header 
		ON dbo.IB_AP_Detail.IB_AP_ID = dbo.IB_AP_Header.IB_AP_ID Where dbo.IB_AP_Header.rbr_date Between @startDate and @endDate


Delete IB_AP_Header  Where rbr_date Between @startDate and @endDate




  /* Insert records into IB_AP_Header table */  
         



        INSERT
          INTO  IB_AP_Header
                (
		contract_number,                               
		rbr_date,
		Vendor_Code,
		amount,               
		doc_ctrl_num_base,
		doc_ctrl_num_type
                )
        SELECT       
		Contract_number, 
		RBR_Date, 
		Vendor_Code, 
		sum(Amount) Amount,
		'C' + RIGHT(CONVERT(varchar, contract_number + 10000000000), 10) +  'I' doc_ctrl_num_base,  
		NULL  doc_ctrl_num_type
FROM         dbo.IB_ARAP_Detail
where Subleger='AP' AND Amount<>0 and dbo.IB_ARAP_Detail.RBR_Date Between @startDate and @endDate
group by  RBR_Date, Vendor_Code,  Contract_number
HAVING sum(Amount)<>0



/* Determine the type of records (Invoice or Adjustment) 
 * Make the first record an invoice and all others adjustments
 * when sorted by transaction date and ar_export_id
 */
        UPDATE  IB_AP_Header
           SET  doc_ctrl_num_type = 'I'
         WHERE  doc_ctrl_num_type IS NULL
	   AND	rbr_date = 
		(
		SELECT	MIN(AP2.rbr_date)
		  FROM	IB_AP_Header AP2
		 WHERE	AP2.doc_ctrl_num_base = IB_AP_Header.doc_ctrl_num_base
		   AND	AP2.Vendor_Code = IB_AP_Header.Vendor_Code
		)
	  
	   AND	NOT EXISTS
		(
                /* eliminate new transactions that are adjustments
		 * of existing invoices.
		 */
		SELECT	*
		  FROM	IB_AP_Header APExists
		 WHERE	APExists.doc_ctrl_num_type = 'I'
		   AND	APExists.doc_ctrl_num_base = IB_AP_Header.doc_ctrl_num_base
		   AND	APExists.Vendor_Code = IB_AP_Header.Vendor_Code
		)

        /* set remaining transactions to be adjustments */
        UPDATE  IB_AP_Header
           SET  doc_ctrl_num_type = 'A'
         WHERE  doc_ctrl_num_type IS NULL


/* Set sequence numbers
 * Use two correlated subqueries. The first calculates the maximum existing 
 * sequence number and the second calculates the record's position within the 
 * new records for this base.
 */
	UPDATE	IB_AP_Header
	   SET	doc_ctrl_num_seq =
		(
		SELECT	existing.max_seq + new.position
		  FROM	(
			SELECT	ISNULL(MAX(doc_ctrl_num_seq), 0) max_seq
			  FROM	IB_AP_Header AP2
			 WHERE	AP2.doc_ctrl_num_base =	IB_AP_Header.doc_ctrl_num_base
			   AND	AP2.doc_ctrl_num_type =	IB_AP_Header.doc_ctrl_num_type
			) existing,
			(
			SELECT	COUNT(*) + 1 position
			  FROM	IB_AP_Header AP3
			 WHERE	AP3.doc_ctrl_num_seq IS	NULL
			   AND	AP3.doc_ctrl_num_base =	IB_AP_Header.doc_ctrl_num_base
			   AND	AP3.doc_ctrl_num_type =	IB_AP_Header.doc_ctrl_num_type
			   AND	AP3.IB_AP_ID < IB_AP_Header.IB_AP_ID			  
			) new
		)
	 WHERE  doc_ctrl_num_seq IS NULL
/* Link adjustments to original invoices */
        UPDATE  IB_AP_Header
           SET  apply_to_doc_ctrl_num =
                        (
                        SELECT  IB_AP_Header.doc_ctrl_num_base + 'I' +
                                  RIGHT(CONVERT(varchar,
                                  MAX(AP2.doc_ctrl_num_seq) +
                                  1000), 3)
                          FROM  IB_AP_Header AP2
                         WHERE  AP2.doc_ctrl_num_base =
                                  IB_AP_Header.doc_ctrl_num_base
                           AND  AP2.Vendor_Code = IB_AP_Header.Vendor_Code

                           AND  AP2.doc_ctrl_num_type = 'I'
                        )
         WHERE  doc_ctrl_num_type = 'A'
           AND  apply_to_doc_ctrl_num IS NULL


--select * from IB_ARAP_Detail
-- Detail

INSERT INTO 
	IB_AP_Detail (
	IB_AP_ID ,
	Expense_Account,
	Amount
) 

SELECT  dbo.IB_AP_Header.IB_AP_ID, 
	dbo.IB_ARAP_Detail.Revenue_Account, 
	SUM(dbo.IB_ARAP_Detail.Amount) AS Amount
FROM    dbo.IB_ARAP_Detail INNER JOIN
                      dbo.IB_AP_Header ON dbo.IB_ARAP_Detail.Contract_number = dbo.IB_AP_Header.Contract_Number AND 
                      dbo.IB_ARAP_Detail.RBR_Date = dbo.IB_AP_Header.RBR_Date AND 
                      dbo.IB_ARAP_Detail.Vendor_Code = dbo.IB_AP_Header.Vendor_Code
where IB_ARAP_Detail.Amount<>0 and dbo.IB_AP_Header.RBR_Date Between @startDate and @endDate
GROUP BY dbo.IB_AP_Header.IB_AP_ID, dbo.IB_ARAP_Detail.Revenue_Account
Having SUM(dbo.IB_ARAP_Detail.Amount) <>0

INSERT INTO 
	IB_AP_Detail (
	IB_AP_ID ,
	Expense_Account,
	Amount
) 

SELECT     dbo.IB_AP_Header.IB_AP_ID, 
APVend.AP_Interbranch_Account, 
CONVERT(DECIMAL(9,2), SUM(CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Amount) * CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Commission_Rate)))* (- 1.00) AS Amount
FROM         dbo.IB_ARAP_Detail  INNER JOIN
                      dbo.IB_ARCust_APVend_vw APVend ON IB_ARAP_Detail.Vendor_Code = APVend.Vendor_code INNER JOIN
                      dbo.IB_AP_Header ON IB_ARAP_Detail.Contract_number = dbo.IB_AP_Header.Contract_Number AND 
                      IB_ARAP_Detail.RBR_Date = dbo.IB_AP_Header.RBR_Date AND IB_ARAP_Detail.Vendor_code = dbo.IB_AP_Header.Vendor_Code
WHERE     (IB_ARAP_Detail.Subleger = 'AP') AND IB_ARAP_Detail.Amount<>0 and dbo.IB_AP_Header.RBR_Date Between @startDate and @endDate

GROUP BY dbo.IB_AP_Header.IB_AP_ID, APVend.AP_Interbranch_Account
HAVING sum(dbo.IB_ARAP_Detail.Amount*dbo.IB_ARAP_Detail.Commission_Rate)<>0


INSERT INTO 
	IB_AP_Detail (
	IB_AP_ID ,
	Expense_Account,
	Amount
) 
SELECT   dbo.IB_AP_Header.IB_AP_ID, 
		TaxRate.Payables_Clearing_Contra, 
		--CONVERT(DECIMAL(9,2), SUM(CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Amount) * CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Commission_Rate)))* (- 1.00) AS Amount
		CONVERT(DECIMAL(9,2), SUM(CONVERT(DECIMAL(11,4), IB_ARAP_Detail.Amount) * CONVERT(DECIMAL(11,4), 1.00-IB_ARAP_Detail.Commission_Rate))*TaxRate.Tax_Rate/100.00) AS Amount

FROM         dbo.IB_ARAP_Detail  
	INNER JOIN dbo.IB_ARCust_APVend_vw APVend 
		ON IB_ARAP_Detail.Vendor_Code = APVend.Vendor_code 
	INNER JOIN  dbo.IB_AP_Header 
		ON IB_ARAP_Detail.Contract_number = dbo.IB_AP_Header.Contract_Number AND 
                      IB_ARAP_Detail.RBR_Date = dbo.IB_AP_Header.RBR_Date AND IB_ARAP_Detail.Vendor_code = dbo.IB_AP_Header.Vendor_Code
	Inner Join   
          
          (
           SELECT  Valid_From, Valid_To, Tax_Type, Tax_Rate, Rate_Type, Last_Changed_By, Last_Changed_On, Payables_Clearing_Contra
				FROM  Tax_Rate
		   WHERE (Tax_Type IN ('HST', 'GST')) 
		   ) TaxRate  on IB_ARAP_Detail.RBR_Date >=TaxRate.Valid_from and IB_ARAP_Detail.RBR_Date<=TaxRate.Valid_To
                         
WHERE     (IB_ARAP_Detail.Subleger = 'AP') AND IB_ARAP_Detail.Amount<>0 and dbo.IB_AP_Header.RBR_Date Between @startDate and @endDate
 --And IB_ARAP_Detail.Contract_Currency_ID=1
 And IB_ARAP_Detail.IB_Zone<>'US'
--and IB_ARAP_Detail.contract_number=1911970
GROUP BY dbo.IB_AP_Header.IB_AP_ID, APVend.AP_Interbranch_Account, TaxRate.Payables_Clearing_Contra,TaxRate.Tax_Rate
--HAVING sum(dbo.IB_ARAP_Detail.Amount*dbo.IB_ARAP_Detail.Commission_Rate)<>0
GO
