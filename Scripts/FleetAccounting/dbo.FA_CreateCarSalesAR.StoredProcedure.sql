USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_CreateCarSalesAR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[FA_CreateCarSalesAR]  --  '2008-07-21','2009-03-31'
		@paramStartDate Varchar(24),
		@paramEndDate Varchar(24)
As


Declare @dProcessStartDate Datetime
Declare @dProcessEndDate Datetime
Select @dProcessStartDate=Convert(Datetime, NULLIF(@paramStartDate,''))
Select @dProcessEndDate=Convert(Datetime, NULLIF(@paramEndDate,''))

--select * from Vehicle where Sell_To is not null
 
--Create Vehicle Purchase AR Transaction for Generating AR Invoice and GL Entry
Select * Into  #ARTransaction from
(


--- Car Sales AR
-- Vehicle Cost
SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 
				   V.Vehicle_Cost as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'Vehicle Asset' as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
				 --'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				 'CS' as  Document_Type,
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
WHERE       (V.Selling_Price > 0) And (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)

Union 

   -- update  Vehicle   set Price_Difference=(Case When Price_Difference is null then 0 Else Price_Difference End) WHERE     (Selling_Price > 0)

-- Gain Loss
SELECT   V.Unit_Number,  
			    Sales_Processed_date as RBR_Date, 
				V.OSD as DATEINVC,
			    Sell_To as Customer_Account, 		

				V.Selling_Price
				  -
				  (
                            --NBV
						  (
						   dbo.VehCurrentBookValue(V.Unit_Number, Getdate())  -dbo.ZeroIfNull(V.Price_Difference)
										
							)   -- End NBV				
                   		-    (dbo.ZeroIfNull(Deduction)	+dbo.ZeroIfNull(KM_Charge))
					 )
					As Amount,		 

--			    (Selling_Price-
--							((BookValue-dbo.ZeroIfNull(V.Price_Difference))-                      -- Net Book Value (NBV)
--										(-dbo.ZeroIfNull(Damage_Amount)+-dbo.ZeroIfNull(KM_Charge))
--							)
--				 )   as Amount , 
				 Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'GAIN/Loss On Disposal' as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				'CS' as  Document_Type,
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
--Inner Join
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number

WHERE  	(V.Selling_Price
					  -
					  (
								--NBV
							  (
							   dbo.VehCurrentBookValue(V.Unit_Number, Getdate())  -dbo.ZeroIfNull(V.Price_Difference)
											
								)   -- End NBV				
                   			-    (dbo.ZeroIfNull(Deduction)	+dbo.ZeroIfNull(KM_Charge))
						 )
				)<>0

				And Selling_Price<>0	
				And (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)

 				
Union

--Sales GST

SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 				 
				  Sales_GST as Amount , 
				 Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'Sales GST' as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
				-- 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				'CS' as  Document_Type,	
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
WHERE    (V.Selling_Price > 0) And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate) And Sales_GST<>0

Union

--Sales_PST
SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 				 
				  Sales_PST as Amount , 
				 Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'Sales PST' as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				'CS' as  Document_Type,	
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
WHERE    (V.Selling_Price > 0) And (Sales_PST is not null and Sales_PST<>0) And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate) 

Union

-- Total Sales Amount
-- For Reference Only
--SELECT    V.Unit_Number,  
--				  Sales_Processed_date as RBR_Date, 
--				  V.OSD as DATEINVC,
--				  Sell_To as Customer_Account, 				 
--				 ( 
--						Selling_Price+
--						dbo.ZeroIfNull( Sales_GST)+dbo.ZeroIfNull(Sales_PST)  
--				 )* (-1) as Amount , 
--				 Getdate() as Transaction_Date,
--				 'FA Sales AR' As Transaction_Type,	
--				 'Sales Clearing Accounting' as RevenueItem,
--				 'Sales Clearing Accounting' As ClearingAccount,
--				 'Sales - ' +V.Serial_Number as INVCDESC,
--				 V.Vehicle_Class_Code,
--				 V.Program,
----				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
--				 'CS' as  Document_Type,
--				  'I' as Doc_Ctrl_Num_Type, 
--				 1 as Doc_Ctrl_Num_Seq, 
--				 NULL as Apply_To_Doc_Ctrl_Num
--FROM         dbo.Vehicle V
--WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate) 
--
--Union

-- Accumulated Depreciation

SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				   V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 
				  (Vehicle_Cost- dbo.VehCurrentBookValue(V.Unit_Number, Getdate())) *(-1)  as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'Accumulated Depreciation' as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
				-- 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				'CS' as  Document_Type,
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
--Inner Join
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number

WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)  and   (Vehicle_Cost- dbo.VehCurrentBookValue(V.Unit_Number, Getdate())) <>0
 


Union
-- Deduction/Damage Amount
SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 
				 dbo.ZeroIfNull(Deduction) * (-1)
					as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
                 (Case When V.Program=1 Then  'Loss on Turn Back Due to Missing Parts' 
							Else 'Loss Due to Damage, Total Wreck, Missing Parts'
				 End)	as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
				 --'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				'CS' as  Document_Type,	
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)  and (dbo.ZeroIfNull(Deduction)   >0 )
Union
-- KM Charge
SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				   V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 
				  dbo.ZeroIfNull( KM_Charge)  *(-1) as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'KM Charge' as RevenueItem,
				 'Sales Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
				 --'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'CS' AS  Doc_Ctrl_Num_Base, 
				'CS' as  Document_Type,	
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle V
WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)  and ( dbo.ZeroIfNull( KM_Charge)   >0)


UNION
-- Price Pretection for Car Sales entry
SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  Sell_To as Customer_Account, 
				  dbo.ZeroIfNull(V.Price_Difference) *(-1) as Amount , 				 
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'Price Protection' as RevenueItem,
				 'Price Protection Clearing Accounting' As ClearingAccount,
				 'Sales - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'PP' AS  Doc_Ctrl_Num_Base, 
				 'CS' as  Document_Type,	
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
					INNER JOIN dbo.FA_Dealer 
							ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  
WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)  and ( dbo.ZeroIfNull(V.Price_Difference) >0)


-- Price Pretection  AR
UNION

SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  dbo.FA_Dealer.Customer_Code as Customer_Account, 
				  dbo.ZeroIfNull(V.Price_Difference)  as Amount , 				 
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				 'Price Protection' as RevenueItem,
				 'Price Protection Clearing Accounting' As ClearingAccount,
				 'Price Protection - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'PP' AS  Doc_Ctrl_Num_Base, 
				  'PP' as  Document_Type,
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
					INNER JOIN dbo.FA_Dealer 
							ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  
WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)  and ( dbo.ZeroIfNull(V.Price_Difference) >0)

UNION
-- Price Pretection GST
SELECT    V.Unit_Number,  
				  Sales_Processed_date as RBR_Date, 
				  V.OSD as DATEINVC,
				  dbo.FA_Dealer.Customer_Code as Customer_Account, 
				 -- dbo.ZeroIfNull(V.Price_Difference) *(-1) as Amount , 		
				 Round(V.Price_Difference *(Tax_Rate/100),2)	 as Amount , 		
				  Getdate() as Transaction_Date,
				 'FA Sales AR' As Transaction_Type,	
				  'Sales GST' as RevenueItem,
				 'Price Protection Clearing Accounting' As ClearingAccount,
				 'Price Protection - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'PP' AS  Doc_Ctrl_Num_Base, 
				  'PP' as  Document_Type,
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
					INNER JOIN dbo.FA_Dealer 
							ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  
					INNER JOIN dbo.Tax_Rate AS TaxRate  
							ON   V.Sales_Processed_date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')

WHERE    (V.Selling_Price > 0)  And    (Sales_Processed_date between @dProcessStartDate and @dProcessEndDate)  and ( dbo.ZeroIfNull(V.Price_Difference) >0)



) FAARTran


--Select  * from  #ARTransaction
--======================================================================================================
-- Creating Vehicle Purchase AR

-- AR Invoice

		Delete FA_AR_Detail
		FROM         dbo.FA_AR_Detail AS ARDet INNER JOIN
							  dbo.FA_AR_Header AS ARHd ON ARDet.AR_ID = ARHd.AR_ID
		Where ARHd.rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type= 'FA Sales AR' 


		Delete FA_AR_Header  Where rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type= 'FA Sales AR' 

       -- Everything in Detail Level First

        INSERT
          INTO   FA_AR_Header
                (
				Transaction_Type,
				RBR_Date,
				Document_Number,                               
				Document_Date,				
				Customer_Account,
				Document_Description,
				Amount, 
				Summary_Level,              
				Doc_Ctrl_Num_Base,
				Doc_Ctrl_Num_Type
                )


				Select   Transaction_Type, 
							RBR_Date, 
							Unit_Number, 
							DATEINVC,
							Customer_Account, 			
							INVCDESC,
							Sum(Amount) as Amount,          
							CRAuth.summary_level , 
							'V'+
							(Case When CRAuth.summary_level<>'C' Or  CRAuth.summary_level IS Null Then   Ltrim( rtrim(Convert(Varchar(10),FAAR.Unit_Number))) Else   Ltrim( rtrim(Customer_Account ))End)+ 
							Document_Type  AS Doc_Ctrl_Num_Base, 
							'I' As Doc_Ctrl_Num_Type			
				From		#ARTransaction FAAR
				LEFT OUTER JOIN	dbo.AR_Credit_Authorization CRAuth 
							ON  FAAR.Customer_Account=CRAuth.Customer_Code 

				where  FAAR.RBR_Date Between @dProcessStartDate and @dProcessEndDate and FAAR.Transaction_Type= 'FA Sales AR' 
                				group by FAAR.Transaction_Type, FAAR.RBR_Date, FAAR.Customer_Account,  FAAR.Unit_Number ,FAAR.INVCDESC, FAAR.DATEINVC,CRAuth.summary_level , FAAR.Document_Type
				HAVING sum(Amount)<>0


/*
* Determine the type of records (Invoice or Adjustment) 
 * Make the first record an invoice and all others adjustments
 * when sorted by transaction date and ar_export_id
 */
        UPDATE  FA_AR_Header
           SET  doc_ctrl_num_type = 'I'
         WHERE  doc_ctrl_num_type IS NULL
	   AND	rbr_date = 
		(
		SELECT	MIN(ar2.rbr_date)
		  FROM	FA_AR_Header ar2
		 WHERE	ar2.doc_ctrl_num_base = FA_AR_Header.doc_ctrl_num_base
		   AND	ar2.customer_account = FA_AR_Header.customer_account
		)
	  
	   AND	NOT EXISTS
		(
                /* eliminate new transactions that are adjustments
		 * of existing invoices.
		 */
		SELECT	*
		  FROM	FA_AR_Header arExists
		 WHERE	arExists.doc_ctrl_num_type = 'I'
		   AND	arExists.doc_ctrl_num_base = FA_AR_Header.doc_ctrl_num_base
		   AND	arExists.customer_account = FA_AR_Header.customer_account
		)

        /* set remaining transactions to be adjustments */
        UPDATE  FA_AR_Header
           SET  doc_ctrl_num_type = 'A'
         WHERE  doc_ctrl_num_type IS NULL


/* Set sequence numbers
 * Use two correlated subqueries. The first calculates the maximum existing 
 * sequence number and the second calculates the record's position within the 
 * new records for this base.
 */
	UPDATE	FA_AR_Header
	   SET	doc_ctrl_num_seq =
		(
		SELECT	existing.max_seq + new.position
		  FROM	(
			SELECT	ISNULL(MAX(doc_ctrl_num_seq), 0) max_seq
			  FROM	FA_AR_Header ar2
			 WHERE	ar2.doc_ctrl_num_base =	FA_AR_Header.doc_ctrl_num_base
			   AND	ar2.doc_ctrl_num_type =	FA_AR_Header.doc_ctrl_num_type
			) existing,
			(
			SELECT	COUNT(*) + 1 position
			  FROM	FA_AR_Header ar3
			 WHERE	ar3.doc_ctrl_num_seq IS	NULL
			   AND	ar3.doc_ctrl_num_base =	FA_AR_Header.doc_ctrl_num_base
			   AND	ar3.doc_ctrl_num_type =	FA_AR_Header.doc_ctrl_num_type
			   AND	ar3.AR_ID < FA_AR_Header.AR_ID			  
			) new
		)
	 WHERE  doc_ctrl_num_seq IS NULL
/* Link adjustments to original invoices */
        UPDATE  FA_AR_Header
           SET  apply_to_doc_ctrl_num =
                        (
                        SELECT  FA_AR_Header.doc_ctrl_num_base + 'I' +
                                  RIGHT(CONVERT(varchar,
                                  MAX(ar2.doc_ctrl_num_seq) +
                                  1000), 3)
                          FROM  FA_AR_Header ar2
                         WHERE  ar2.doc_ctrl_num_base =
                                  FA_AR_Header.doc_ctrl_num_base
                           AND  ar2.customer_account = FA_AR_Header.customer_account

                           AND  ar2.doc_ctrl_num_type = 'I'
                        )
         WHERE  doc_ctrl_num_type = 'A'
           AND  apply_to_doc_ctrl_num IS NULL



INSERT INTO 
	FA_AR_Detail (
	AR_ID ,
	Revenue_Account,
	Amount
) 

Select   FAARH.AR_ID,
            GL.GL_Number as RevenueAccount,
			 sum(FAAR.Amount) Amount
			
From
(

				Select   Transaction_Type, 
							RBR_Date, 
							Unit_Number, 
							DATEINVC,
							Customer_Account, 			
							INVCDESC,
							Sum(Amount) as Amount,          
							CRAuth.summary_level , 
							'V'+
							(Case When CRAuth.summary_level<>'C' Or  CRAuth.summary_level IS Null Then   Ltrim( rtrim(Convert(Varchar(10),FAAR.Unit_Number))) Else   Ltrim( rtrim(Customer_Account ))End)+ 
							Document_Type  AS Doc_Ctrl_Num_Base, 
							'I' As Doc_Ctrl_Num_Type,
							Vehicle_Class_Code,		
							ClearingAccount,
							Program			
				From		#ARTransaction FAAR
				LEFT OUTER JOIN	dbo.AR_Credit_Authorization CRAuth 
							ON  FAAR.Customer_Account=CRAuth.Customer_Code 

				where  FAAR.RBR_Date Between @dProcessStartDate and @dProcessEndDate and FAAR.Transaction_Type= 'FA Sales AR' 
                				group by FAAR.Transaction_Type, FAAR.RBR_Date, FAAR.Customer_Account,  FAAR.Unit_Number ,FAAR.INVCDESC, FAAR.DATEINVC,CRAuth.summary_level , FAAR.Document_Type,
											Vehicle_Class_Code,		
											ClearingAccount,
											Program
				HAVING sum(Amount)<>0

)
FAAR

INNER JOIN dbo.Vehicle_Class VC 
					ON FAAR.Vehicle_Class_Code = VC.Vehicle_Class_Code
 Inner Join dbo.FA_GL GL 
					On FAAR.ClearingAccount=GL.Accounting_Item and FAAR .Program=GL.Program  And  VC.FA_Vehicle_Type_ID=GL.Vehicle_Type
Inner Join dbo.FA_AR_Header FAARH
					On FAAR.Unit_Number=FAARH.Document_Number 
					And  FAAR.RBR_Date=FAARH.RBR_Date 
					And FAAR.Customer_Account=FAARH.Customer_Account
					And FAAR.Doc_Ctrl_Num_Base=FAARH.Doc_Ctrl_Num_Base
				   And  FAAR.Doc_Ctrl_Num_Type=FAARH.Doc_Ctrl_Num_Type 
				   And  FAAR.INVCDESC=FAARH.Document_Description


LEFT OUTER JOIN
   dbo.AR_Credit_Authorization CRAuth ON  FAAR.Customer_Account=CRAuth.Customer_Code 
--Where RevenueItem<>'Sales Clearing Accounting'  
Group By AR_ID,  GL.GL_Number
/*		
 SELECT       
		Contract_number, 
		RBR_Date, 
		Customer_code, 
		sum(Amount) Amount,
		'C' + RIGHT(CONVERT(varchar, contract_number + 10000000000), 10) +  'I' doc_ctrl_num_base,  
		NULL  doc_ctrl_num_type
FROM         dbo.ARAP_Detail
where Subleger='AR' AND Amount<>0 and dbo.ARAP_Detail.RBR_Date Between @startDate and @endDate
group by  RBR_Date, Customer_code,  Contract_number
HAVING sum(Amount)<>0
*/

 Delete FA_Sales_Journal  Where rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type= 'FA Sales AR' 

-- GL Entry
Insert Into FA_Sales_Journal (RBR_Date,	Document_Number,	Transaction_Type,	Entry_Date,	GL_Account,Amount)
Select RBR_Date, Convert(Varchar(12), Unit_Number),GLTrans.Transaction_Type, DATEENTRY, GL.GL_Number, Amount  from 

(

SELECT   ARTrans.RBR_Date,  ARTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY, ARTrans.Amount *(-1) as Amount, ARTrans.RevenueItem GLItem, dbo.Vehicle_Class.FA_Vehicle_Type_ID, ARTrans.Program
FROM         #ARTransaction AS ARTrans INNER JOIN
                      dbo.Vehicle_Class ON ARTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
-- Debit  Clearing Account
Union
SELECT  ARTrans.RBR_Date,    ARTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY, Amount ,                                            ClearingAccount as GLItem , dbo.Vehicle_Class.FA_Vehicle_Type_ID, ARTrans.Program
FROM       #ARTransaction AS ARTrans INNER JOIN
                      dbo.Vehicle_Class ON ARTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code  


) GLTrans Inner Join dbo.FA_GL GL on GLTrans.GLItem=GL.Accounting_Item and GLTrans .Program=GL.Program And GLTrans.FA_Vehicle_Type_ID=GL.Vehicle_Type
--select * from vehicle where Price_Difference is not null and Price_Difference<>0

GO
