USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_CreateVehiclePurchaseAP]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[FA_CreateVehiclePurchaseAP] --  '2009-07-28', '2009-07-28'
		@paramStartDate Varchar(24),
		@paramEndDate Varchar(24)
As


Declare @dProcessStartDate Datetime
Declare @dProcessEndDate Datetime
Select @dProcessStartDate=Convert(Datetime, NULLIF(@paramStartDate,''))
Select @dProcessEndDate=Convert(Datetime, NULLIF(@paramEndDate,''))


 
--Create Vehicle Purchase AR Transaction for Generating AR Invoice and GL Entry
Select * Into  #APTransaction from
(
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
				(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				  dbo.FA_Dealer.Vendor_Code, 
				  V.Purchase_Price + dbo.ZeroIfNull(Purchase_PST) as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AP' As Transaction_Type,	
				 'Vehicle Asset' as Expense_Account,
				 'Purchase Clearing Account' As ClearingAccount,
				 'Purchase - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PS' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  

WHERE      (V.Purchase_Price > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
            --  And V.ISD is Not Null

Union

SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
				(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				  dbo.FA_Dealer.Vendor_Code, 
				  V.Purchase_GST  as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AP' As Transaction_Type,	
				 'Purchase GST' as Expense_Account,
				 'Purchase Clearing Account' As ClearingAccount,
				 'Purchase - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PS' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  
 

WHERE      (V.Purchase_GST > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
            --  And V.ISD is Not Null

Union 
-- C.	PDI not incude in price, and but performed by budget 
 
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
				(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				   dbo.FA_Dealer.Vendor_Code,  
				  V.PDI_Amount as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AP' As Transaction_Type,	
				 'Vehicle Asset' as Expense_Account,
				 'Purchase Clearing Account' As ClearingAccount,
				 'Purchase - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PS' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num

FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  

WHERE      (V.PDI_Included_In_Price = 0) AND (V.PDI_Performed_By = 'Own') AND (V.PDI_Amount > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
            --  And V.ISD is Not Null

Union 
-- C.	PDI not incude in price, and but performed by budget  -- Off Set Clearing Account
 
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
				(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				 dbo.FA_Dealer.Vendor_Code, 
				  V.PDI_Amount*(-1) as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AP' As Transaction_Type,	
				 'PDI Revenue' as Expense_Account,
				 'Purchase Clearing Account' As ClearingAccount,
				 'Purchase - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PS' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num

FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  

WHERE      (V.PDI_Included_In_Price = 0) AND (V.PDI_Performed_By = 'Own') AND (V.PDI_Amount > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
            --  And V.ISD is Not Null


Union


-- D.	PDI not incude in price, and not perform by budget (Peformed by third party) 
 
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
				(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				  V.PDI_Performed_By Vendor_Code, 
				  V.PDI_Amount as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AP' As Transaction_Type,	
				 'Vehicle Asset' as Expense_Account,
				 'Purchase Clearing Account' As ClearingAccount,
				 'PDI - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PD' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  

WHERE      (V.PDI_Included_In_Price = 0) AND (V.PDI_Performed_By <> 'Own') AND (V.PDI_Amount > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
            --  And V.ISD is Not Null

Union

 
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
			    (	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				  V.PDI_Performed_By Vendor_Code, 
				  Round(V.PDI_Amount  *(Tax_Rate/100),2)as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AP' As Transaction_Type,	
				 'Purchase GST' as Expense_Account,
				 'Purchase Clearing Account' As ClearingAccount,
				 'PDI - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PD' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 

                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  
                     INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')

WHERE     (V.PDI_Included_In_Price = 0) AND (V.PDI_Performed_By <> 'Own') AND (V.PDI_Amount > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
            --  And V.ISD is Not Null





) FAAPTran

--======================================================================================================
-- Creating Vehicle Purchase AR

-- AR Invoice

      
	Delete FA_AP_Detail
	FROM         dbo.FA_AP_Detail APDet INNER JOIN
						  dbo.FA_AP_Header APHd ON APDet.AP_ID = APHd.AP_ID
	Where APHd.rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type='FA Purchase AP'

	Delete FA_AP_Header  Where rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type='FA Purchase AP'

       -- Everything in Detail Level First
 

        INSERT
          INTO   FA_AP_Header
                (
				Transaction_Type,
				RBR_Date,
				Document_Number,                               
				Document_Date,				
				Vendor_Code,
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
							Vendor_Code, 			
							INVCDESC,
							Sum(Amount) as Amount,          
							--SUM(Round(Amount *(1+Tax_Rate/100),2)) as Amount , 
							CRAuth.summary_level , 
							'V'+
							(Case When CRAuth.summary_level<>'C' Or  CRAuth.summary_level IS Null Then Ltrim( rtrim(Convert(Varchar(10),FAAP.Unit_Number))) Else  Ltrim( rtrim(Vendor_Code ))End)+ 
							Document_Type  AS Doc_Ctrl_Num_Base, 
							'I' As Doc_Ctrl_Num_Type			
				From		#APTransaction FAAP
--                Inner Join Tax_Rate 
--									On FAAP.RBR_Date  between Tax_Rate.Valid_From And  Tax_Rate.Valid_To And Tax_Type='GST'

				LEFT OUTER JOIN	dbo.AR_Credit_Authorization CRAuth 
							ON  FAAP.Vendor_Code=CRAuth.Customer_Code 

				where  FAAP.RBR_Date Between @dProcessStartDate and @dProcessEndDate and FAAP.Transaction_Type='FA Purchase AP'
                				group by FAAP.Transaction_Type, FAAP.RBR_Date, FAAP.Vendor_Code,  FAAP.Unit_Number ,FAAP.INVCDESC, FAAP.DATEINVC,CRAuth.summary_level , FAAP.Document_Type
				HAVING sum(Amount)<>0


/*
* Determine the type of records (Invoice or Adjustment) 
 * Make the first record an invoice and all others adjustments
 * when sorted by transaction date and ar_export_id
 */
        UPDATE  FA_AP_Header
           SET  doc_ctrl_num_type = 'I'
         WHERE  doc_ctrl_num_type IS NULL
	   AND	rbr_date = 
		(
		SELECT	MIN(ap2.rbr_date)
		  FROM	FA_AP_Header ap2
		 WHERE	ap2.doc_ctrl_num_base = FA_AP_Header.doc_ctrl_num_base
		   AND	ap2.Vendor_Code = FA_AP_Header.Vendor_Code
		)
	  
	   AND	NOT EXISTS
		(
                /* eliminate new transactions that are adjustments
		 * of existing invoices.
		 */
		SELECT	*
		  FROM	FA_AP_Header arExists
		 WHERE	arExists.doc_ctrl_num_type = 'I'
		   AND	arExists.doc_ctrl_num_base = FA_AP_Header.doc_ctrl_num_base
		   AND	arExists.Vendor_Code = FA_AP_Header.Vendor_Code
		)

        /* set remaining transactions to be adjustments */
        UPDATE  FA_AP_Header
           SET  doc_ctrl_num_type = 'A'
         WHERE  doc_ctrl_num_type IS NULL


/* Set sequence numbers
 * Use two correlated subqueries. The first calculates the maximum existing 
 * sequence number and the second calculates the record's position within the 
 * new records for this base.
 */
	UPDATE	FA_AP_Header
	   SET	doc_ctrl_num_seq =
		(
		SELECT	existing.max_seq + new.position
		  FROM	(
			SELECT	ISNULL(MAX(doc_ctrl_num_seq), 0) max_seq
			  FROM	FA_AP_Header ap2
			 WHERE	ap2.doc_ctrl_num_base =	FA_AP_Header.doc_ctrl_num_base
			   AND	ap2.doc_ctrl_num_type =	FA_AP_Header.doc_ctrl_num_type
			) existing,
			(
			SELECT	COUNT(*) + 1 position
			  FROM	FA_AP_Header ar3
			 WHERE	ar3.doc_ctrl_num_seq IS	NULL
			   AND	ar3.doc_ctrl_num_base =	FA_AP_Header.doc_ctrl_num_base
			   AND	ar3.doc_ctrl_num_type =	FA_AP_Header.doc_ctrl_num_type
			   AND	ar3.AP_ID < FA_AP_Header.AP_ID			  
			) new
		)
	 WHERE  doc_ctrl_num_seq IS NULL
/* Link adjustments to original invoices */
        UPDATE  FA_AP_Header
           SET  apply_to_doc_ctrl_num =
                        (
                        SELECT  FA_AP_Header.doc_ctrl_num_base + 'I' +
                                  RIGHT(CONVERT(varchar,
                                  MAX(ap2.doc_ctrl_num_seq) +
                                  1000), 3)
                          FROM  FA_AP_Header ap2
                         WHERE  ap2.doc_ctrl_num_base =
                                  FA_AP_Header.doc_ctrl_num_base
                           AND  ap2.Vendor_Code = FA_AP_Header.Vendor_Code

                           AND  ap2.doc_ctrl_num_type = 'I'
                        )
         WHERE  doc_ctrl_num_type = 'A'
           AND  apply_to_doc_ctrl_num IS NULL

 

INSERT INTO 
	FA_AP_Detail (
	AP_ID ,
	Expense_Account,
	Amount
) 

Select   FAAPH.AP_ID,
            GL.GL_Number as ExpenseAccount,
            SUM(FAAP.Amount) AS Amount
			--SUM(Round(FAAP.Amount *(1+Tax_Rate/100),2)) as Amount 
			
From
(

	Select   Transaction_Type, 
							RBR_Date, 
							Unit_Number, 
							DATEINVC,
							Vendor_Code, 			
							INVCDESC,
							Sum(Amount) as Amount,          
							--SUM(Round(Amount *(1+Tax_Rate/100),2)) as Amount , 
							CRAuth.summary_level , 
							'V'+
							(Case When CRAuth.summary_level<>'C' Or  CRAuth.summary_level IS Null Then Ltrim( rtrim(Convert(Varchar(10),FAAP.Unit_Number))) Else  Ltrim( rtrim(Vendor_Code ))End)+ 
							Document_Type  AS Doc_Ctrl_Num_Base, 
							'I' As Doc_Ctrl_Num_Type,		
							Vehicle_Class_Code,		
							ClearingAccount,
							Program	
				From		#APTransaction FAAP
--                Inner Join Tax_Rate 
--									On FAAP.RBR_Date  between Tax_Rate.Valid_From And  Tax_Rate.Valid_To And Tax_Type='GST'

				LEFT OUTER JOIN	dbo.AR_Credit_Authorization CRAuth 
							ON  FAAP.Vendor_Code=CRAuth.Customer_Code 

				where  FAAP.RBR_Date Between @dProcessStartDate and @dProcessEndDate and FAAP.Transaction_Type='FA Purchase AP'
                				group by FAAP.Transaction_Type, FAAP.RBR_Date, FAAP.Vendor_Code,  FAAP.Unit_Number ,FAAP.INVCDESC, FAAP.DATEINVC,CRAuth.summary_level , FAAP.Document_Type,
											Vehicle_Class_Code,		
											ClearingAccount,
											Program	
				HAVING sum(Amount)<>0

)

 FAAP
INNER JOIN dbo.Vehicle_Class VC 
					ON FAAP.Vehicle_Class_Code = VC.Vehicle_Class_Code
 Inner Join dbo.FA_GL GL 
					On FAAP.ClearingAccount=GL.Accounting_Item and FAAP .Program=GL.Program  And  VC.FA_Vehicle_Type_ID=GL.Vehicle_Type
Inner Join dbo.FA_AP_Header FAAPH
					On FAAP.Unit_Number=FAAPH.Document_Number 
					And  FAAP.RBR_Date=FAAPH.RBR_Date 
					And FAAP.Vendor_Code=FAAPH.Vendor_Code
					And FAAP.Doc_Ctrl_Num_Base=FAAPH.Doc_Ctrl_Num_Base
				   And  FAAP.Doc_Ctrl_Num_Type=FAAPH.Doc_Ctrl_Num_Type 
				   And  FAAP.INVCDESC=FAAPH.Document_Description
--Inner Join Tax_Rate 
--									On FAAP.RBR_Date  between Tax_Rate.Valid_From And  Tax_Rate.Valid_To And Tax_Type='GST'


LEFT OUTER JOIN
   dbo.AR_Credit_Authorization CRAuth ON  FAAP.Vendor_Code=CRAuth.Customer_Code 
---Where RevenueItem<>'Sales Clearing Accounting'  
Group By AP_ID,  GL.GL_Number




-- GL Entry

 Delete FA_Sales_Journal  Where rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type='FA Purchase AP'

-- GL Entry
Insert Into FA_Sales_Journal (RBR_Date,	Document_Number,	Transaction_Type,	Entry_Date,	GL_Account,Amount)
Select RBR_Date,  Convert(Varchar(12), Unit_Number),GLTrans.Transaction_Type, DATEENTRY, GL.GL_Number, Amount  from 
(
-- Debit Expense Account

-- Expense Account
SELECT  APTrans.RBR_Date,    APTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY, APTrans.Amount  as Amount, APTrans.Expense_Account GLItem, dbo.Vehicle_Class.FA_Vehicle_Type_ID, APTrans.Program
FROM         #APTransaction AS APTrans INNER JOIN
                      dbo.Vehicle_Class ON APTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code

-- Crebit  Clearing Account
Union
SELECT  APTrans.RBR_Date,    APTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY, Amount*(-1) as Amount , ClearingAccount as GLItem , dbo.Vehicle_Class.FA_Vehicle_Type_ID, APTrans.Program
FROM       #APTransaction AS APTrans INNER JOIN
                      dbo.Vehicle_Class ON APTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code 
--				INNER JOIN
--                      dbo.Tax_Rate AS TaxRate  ON   APTrans.RBR_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And Tax_Type='GST'


) GLTrans Inner Join dbo.FA_GL GL on GLTrans.GLItem=GL.Accounting_Item and GLTrans .Program=GL.Program And GLTrans.FA_Vehicle_Type_ID=GL.Vehicle_Type

GO
