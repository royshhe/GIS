USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IRACS_GET_Revenue]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2008-01-10
--	Details		IRACS Submission
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[IRACS_GET_Revenue] --1427075
(
	@CtrctNumber varchar(20)
)
AS
SELECT   dbo.Business_Transaction.Transaction_Date, '8888' OperID,--dbo.Business_Transaction.User_ID, 


	Case
	
		WHEN 
		
			dbo.Contract_Charge_Item.Charge_Type IN (10,11,50,51,52,14,18,33) 
			OR
			(    -- Add Buydown Adjustment 98
				 Optional_Extra.Type IN ('LDW', 'BUYDOWN') OR (dbo.Contract_Charge_Item.Charge_Type = 61 AND dbo.Contract_Charge_Item.Charge_Item_Type = 'a') OR (dbo.Contract_Charge_Item.Charge_Type = 91)  OR (dbo.Contract_Charge_Item.Charge_Type = 98)  
			)
			
			OR
			(
				Optional_Extra.Type IN ('PAI','PEC', 'Cargo','PAE','RSN')  OR   (dbo.Contract_Charge_Item.Charge_Type = 62 AND dbo.Contract_Charge_Item.Charge_Item_Type = 'a') OR  (dbo.Contract_Charge_Item.Charge_Type = 63 AND dbo.Contract_Charge_Item.Charge_Item_Type = 'a') 
                                OR (dbo.Contract_Charge_Item.Charge_Type in (90,92,93))
			)
		Then 'C' 

     -- Add GPS 68
		WHEN dbo.Contract_Charge_Item.Charge_Type IN (23, 34, 37, 39,  96, 97, 20, 34, 36,67,68) OR Optional_Extra.Type in ('Other', 'GPS', 'ELI') Then 'E'
		--Add 41 GPS Recovery
        -- Add 42 Telephone Charge
       -- Add 43 Postage
       -- Add 44 Wind Shiled
      -- Add  99 Seat Removal
		-- add 46/47/48/49
      			    
		WHEN dbo.Contract_Charge_Item.Charge_Type in (13,15,16,17,19,21,22,24,25,26,27,28,29,31,32,38,40,41,42,43,44,46,47,48,49, 60,64,65,66,70,94,95,99) 
				--OR Optional_Extra.Type not in ('LDW', 'BUYDOWN','Other', 'GPS', 'ELI','PAI','PEC', 'Cargo') 
				Then 'O'
		WHEN dbo.Contract_Charge_Item.Charge_Type in (30,35,45) THEN 'T'

	
	
		/*Else
			(Case when dbo.Contract_Charge_Item.Unit_Type in ('Day', 'Hour', 'Month')  then 'E'
			      when dbo.Contract_Charge_Item.Unit_Type='Flat' and dbo.Contract_Charge_Item.Unit_Type not like '%percent%' then 'O'
	                      When dbo.Contract_Charge_Item.Unit_Type like '%percent%' Then 'T'
			End)
		*/
	End AS RevArea, 

       
        Case when dbo.Contract_Charge_Item.Charge_Type IN (64,94,12)  then Optional_Extra.Alias
             Else dbo.Charge_Types_vw.Alias
        End RevCode,

	Case
		When GST_Amount_Included+PST_Amount_Included +PVRT_Amount_Included+GST_Amount+PST_Amount+PVRT_Amount
		+(	
			CASE	WHEN dbo.Contract_Charge_Item.Charge_Type in (30,35,45) THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) 
				ELSE 0
		    	END
    		 )
		<>0 or dbo.Charge_Parameter.Location_Fee is not null then 'Y' 
		Else 'N'
	End AS RevTaxable, 

	Case 
		when dbo.Contract_Charge_Item.Unit_Type='Day' then dbo.Contract_Charge_Item.Unit_Amount 
		Else 0
	End AS RevDaily, 

	Case 
		when dbo.Contract_Charge_Item.Unit_Type<>'Day' then dbo.Contract_Charge_Item.Unit_Amount 
		Else 0
        End AS RevMulti, 
	--dbo.Contract_Charge_Item.Unit_Type, 
	dbo.Contract_Charge_Item.Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) RevAmount
FROM         dbo.Contract_Charge_Item INNER JOIN
                      dbo.Charge_Types_vw ON dbo.Contract_Charge_Item.Charge_Type = dbo.Charge_Types_vw.Code INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID
 LEFT OUTER JOIN
                      dbo.Charge_Parameter ON dbo.Contract_Charge_Item.Charge_Type = dbo.Charge_Parameter.Charge_Type
 LEFT OUTER JOIN
                      Optional_Extra ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID AND Optional_Extra.Delete_Flag = 0
where dbo.Contract_Charge_Item.contract_number =Convert(int, @CtrctNumber)


-- Get Reimbursement
Union All
SELECT     Business_Transaction.Transaction_Date, '8888' AS OperID, 'O' AS RevArea, Charge_Types_vw.Alias AS RevCode, 'N' AS RevTaxable, 0 AS RevDaily, 
                      Contract_Reimbur_and_Discount.Flat_Amount*(-1) AS RevMulti, Contract_Reimbur_and_Discount.Flat_Amount*(-1) AS RevAmount
FROM         Contract_Reimbur_and_Discount  INNER JOIN
                      Business_Transaction ON Contract_Reimbur_and_Discount.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID INNER JOIN
                      Charge_Types_vw ON Contract_Reimbur_and_Discount.Reimbursement_Reason = Charge_Types_vw.[Value]
WHERE   dbo.Contract_Reimbur_and_Discount.contract_number =Convert(int, @CtrctNumber) and  (Contract_Reimbur_and_Discount.Type = 'Reimbursement')


--Get all the Tax
Union All

--- Need to be re-coded
/*Select
max(Transaction_Date),  '8888' AS OperID,  'T' AS RevArea,  'TX'  AS RevCode, 'N' AS RevTaxable, 0 AS RevDaily, 
sum(GST_Amount)+sum(PST_Amount)+sum(PVRT_Amount)+sum(GST_Amount_Included) +sum(PST_Amount_Included)+sum(PVRT_Amount_Included)As RevMulti,
sum(GST_Amount)+sum(PST_Amount)+sum(PVRT_Amount)+sum(GST_Amount_Included) +sum(PST_Amount_Included)+sum(PVRT_Amount_Included) As RevAmount

FROM         dbo.Contract_Charge_Item INNER JOIN
                      dbo.Charge_Types_vw ON dbo.Contract_Charge_Item.Charge_Type = dbo.Charge_Types_vw.Code INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID
 
where dbo.Contract_Charge_Item.contract_number =Convert(int, @CtrctNumber)*/

--GST
Select
max(Transaction_Date),  '8888' AS OperID,  'T' AS RevArea,  'GT'  AS RevCode, 'N' AS RevTaxable, 0 AS RevDaily, 
sum(GST_Amount+GST_Amount_Included) As RevMulti,
sum(GST_Amount+GST_Amount_Included) As RevAmount

FROM         dbo.Contract_Charge_Item 
			INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID

 
where dbo.Contract_Charge_Item.contract_number =Convert(int, @CtrctNumber)

having sum(GST_Amount+GST_Amount_Included)<>0

Union All

--PST

Select
max(Transaction_Date),  '8888' AS OperID,  'T' AS RevArea,  'PS'  AS RevCode, 'N' AS RevTaxable, 0 AS RevDaily, 
sum(PST_Amount+PST_Amount_Included) As RevMulti,
sum(PST_Amount+PST_Amount_Included) As RevAmount

FROM         dbo.Contract_Charge_Item 
			INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID

 
where dbo.Contract_Charge_Item.contract_number =Convert(int, @CtrctNumber)

having sum(PST_Amount+PST_Amount_Included) <>0


Union All

--PVRT

Select
max(Transaction_Date),  '8888' AS OperID,  'E' AS RevArea,  'TX'  AS RevCode, 'N' AS RevTaxable, 0 AS RevDaily, 
sum(PVRT_Amount+PVRT_Amount_Included) As RevMulti,
sum(PVRT_Amount+PVRT_Amount_Included) As RevAmount

FROM         dbo.Contract_Charge_Item 
			INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID

 
where dbo.Contract_Charge_Item.contract_number =Convert(int, @CtrctNumber)

having sum(PVRT_Amount+PVRT_Amount_Included) <>0
GO
