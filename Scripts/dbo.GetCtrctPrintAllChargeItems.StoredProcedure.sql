USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintAllChargeItems]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*  PURPOSE:		To retrieve all charge items (calculaed, manual) for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintAllChargeItems] -- '1854193', '0'
	@ContractNum Varchar(10),
	@BillingCopy as Varchar(1)='0'
AS
DECLARE @iContractNum Int
DECLARE @bBillingCopy BIT

Select @bBillingCopy=CONVERT(bit, @BillingCopy)




	/* 2/27/99 - cpy created - for contract print */
	/* 3/24/99 - cpy bug fix - return reimbursements as negative */
	/* 4/21/99 - cpy bug fix - handle rentback manual charge items */
	
	--if @bCustomerCopy=1

	SELECT	@iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	-- Get calculated charge items ; use Charge_description
		SELECT	cci.Contract_Billing_Party_ID,
		Charge_Description = case when cci.Charge_Type = 31 and vr.rate_name = 'GARS'
					then 'GARS'
					else cci.Charge_Description
					end,
		cci.Unit_Type,
		cci.PVRT_Days,
		GST_Exempt = 0,--Convert(Char(1), convert(int,cci.GST_Exempt)*convert(int,isnull(coe.HST2_Exempt,1))),
		PST_Exempt = Convert(Char(1), cci.PST_Exempt),
		PVRT_Exempt = Convert(Char(1), cci.PVRT_Exempt),
		GST_Include = Convert(Char(1), cci.GST_Included),
		PST_Include = Convert(Char(1), cci.PST_Included),
		PVRT_Include = Convert(Char(1), cci.PVRT_Included),
		Total_Qty = SUM(
											Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' and  @bBillingCopy=0 then
													0
											Else
													cci.Quantity
											End
											),
		Total_Amount = SUM(
											Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' and  @bBillingCopy=0 then
													0
											Else
													cci.Amount
											End
											),
		Total_GST = SUM(cci.GST_Amount),
		Total_PST = SUM(cci.PST_Amount),
		Total_PVRT = SUM(cci.PVRT_Amount),
		oe.Type 
	FROM	Contract_Charge_Item cci
		join contract c
		on c.contract_number = cci.contract_number
		left join (SELECT     dbo.Vehicle_Rate.Rate_ID,  dbo.Vehicle_Rate.Rate_Name,dbo.Vehicle_Rate.Effective_Date, dbo.Vehicle_Rate.Termination_Date, dbo.Vehicle_Rate.Location_Fee_Included, 
                      dbo.Rate_Purpose.Rate_Purpose
					FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Purpose ON dbo.Vehicle_Rate.Rate_Purpose_ID = dbo.Rate_Purpose.Rate_Purpose_ID) vr
		on c.rate_id = vr.rate_id 
		and c.Rate_Assigned_Date between vr.effective_date and vr.termination_date
		left join (Select distinct  Contract_Number,Optional_Extra_ID,HST2_Exempt from contract_optional_extra    Where	Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
			And   Rent_From<>Rent_To) coe
		on c.contract_number=coe.contract_number 
			and cci.optional_extra_id=coe.optional_extra_id	
		left join Optional_Extra oe on oe.Optional_Extra_ID=cci.Optional_Extra_ID 
			
	WHERE	cci.Contract_Number = @iContractNum
	AND	cci.Charge_Item_Type = 'c'
	GROUP BY cci.Contract_Billing_Party_ID, cci.Charge_Description, cci.Unit_Type, cci.PVRT_Days, cci.Charge_Type,
		vr.rate_name,
		 cci.GST_Exempt, Convert(Char(1), cci.PST_Exempt),
		Convert(Char(1), cci.PVRT_Exempt), Convert(Char(1), cci.GST_Included),	
		Convert(Char(1), cci.PST_Included),	Convert(Char(1), cci.PVRT_Included),coe.HST2_Exempt,oe.Type
	HAVING SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' and  @bBillingCopy=0 then
											0
									Else
											cci.Amount
									End
									) + SUM(cci.GST_Amount) + SUM(cci.PST_Amount) + SUM(cci.PVRT_Amount) <> 0
	UNION ALL

	-- Get manual charge items for GIS contracts
	SELECT	Contract_Billing_Party_ID,
		LT.Value,
		Unit_Type,
		PVRT_Days,
		GST_Exempt =Convert(Char(1), convert(int,cci.GST_Exempt)*convert(int,isnull(coe.HST2_Exempt,1))),
		PST_Exempt = Convert(Char(1), cci.PST_Exempt),
		PVRT_Exempt = Convert(Char(1), cci.PVRT_Exempt),
		GST_Include = Convert(Char(1), cci.GST_Included),
		PST_Include = Convert(Char(1), cci.PST_Included),
		PVRT_Include = Convert(Char(1), cci.PVRT_Included),
		Total_Qty = SUM(cci.Quantity),
		Total_Amount = SUM(cci.Amount),
		Total_GST = SUM(cci.GST_Amount),
		Total_PST = SUM(cci.PST_Amount),
		Total_PVRT = SUM(cci.PVRT_Amount),
		oe.type
	FROM	Contract_Charge_Item CCI
		JOIN Contract C
		  ON CCI.Contract_Number = C.Contract_Number
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Manual'
		left join  (Select distinct  Contract_Number,Optional_Extra_ID,HST2_Exempt 
						from contract_optional_extra  
						Where	Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
								And   Rent_From<>Rent_To) coe
		on c.contract_number=coe.contract_number 
			and cci.optional_extra_id=coe.optional_extra_id
		left join Optional_Extra oe on oe.Optional_Extra_ID=cci.Optional_Extra_ID 
	WHERE	CCI.Contract_Number = @iContractNum
	AND	CCI.Charge_Item_Type = 'm'
	AND	NULLIF(C.Foreign_Contract_Number,'') IS NULL
	GROUP BY Contract_Billing_Party_ID, LT.Value, Unit_Type, PVRT_Days,
		 cci.GST_Exempt, Convert(Char(1), cci.PST_Exempt),
		Convert(Char(1), cci.PVRT_Exempt), Convert(Char(1), cci.GST_Included),
		Convert(Char(1), cci.PST_Included), Convert(Char(1), cci.PVRT_Included),coe.HST2_Exempt,oe.Type
	HAVING SUM(cci.Amount) + SUM(cci.GST_Amount) + SUM(cci.PST_Amount) + SUM(cci.PVRT_Amount) <> 0

	UNION ALL

	-- Get manual charge items for Foreign (rentback) contracts
	SELECT	Contract_Billing_Party_ID,
		LT.Value,
		Unit_Type,
		PVRT_Days,
		GST_Exempt = Convert(Char(1), convert(int,cci.GST_Exempt)*convert(int,isnull(coe.HST2_Exempt,1))),
		PST_Exempt = Convert(Char(1), cci.PST_Exempt),
		PVRT_Exempt = Convert(Char(1), cci.PVRT_Exempt),
		GST_Include = Convert(Char(1), cci.GST_Included),
		PST_Include = Convert(Char(1), cci.PST_Included),
		PVRT_Include = Convert(Char(1), cci.PVRT_Included),
		Total_Qty = SUM(cci.Quantity),
		Total_Amount = SUM(cci.Amount),
		Total_GST = SUM(cci.GST_Amount),
		Total_PST = SUM(cci.PST_Amount),
		Total_PVRT = SUM(cci.PVRT_Amount),
		oe.type
	FROM	Contract_Charge_Item CCI
		JOIN Contract C
		  ON CCI.Contract_Number = C.Contract_Number
	     
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Rentback'
		left join  (Select distinct  Contract_Number,Optional_Extra_ID,HST2_Exempt 
						from contract_optional_extra  
						Where	Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
								And   Rent_From<>Rent_To) coe
		on c.contract_number=coe.contract_number 
			and cci.optional_extra_id=coe.optional_extra_id
		left join Optional_Extra oe on oe.Optional_Extra_ID=cci.Optional_Extra_ID 
	WHERE	CCI.Contract_Number = @iContractNum
	AND	CCI.Charge_Item_Type = 'm'
	AND	NULLIF(C.Foreign_Contract_Number,'') IS NOT NULL
	GROUP BY Contract_Billing_Party_ID, LT.Value, Unit_Type, PVRT_Days,
		 cci.GST_Exempt, Convert(Char(1), cci.PST_Exempt),
		Convert(Char(1), cci.PVRT_Exempt), Convert(Char(1), cci.GST_Included),
		Convert(Char(1), cci.PST_Included), Convert(Char(1), cci.PVRT_Included),coe.HST2_Exempt,oe.Type
	HAVING SUM(cci.Amount) + SUM(cci.GST_Amount) + SUM(cci.PST_Amount) + SUM(cci.PVRT_Amount) <> 0

	UNION ALL

	-- Get adjustment charge items
	SELECT	Contract_Billing_Party_ID,
		LT.Value,
		Unit_Type,
		PVRT_Days,
		GST_Exempt = Convert(Char(1), convert(int,cci.GST_Exempt)*convert(int,isnull(coe.HST2_Exempt,1))),
		PST_Exempt = Convert(Char(1), cci.PST_Exempt),
		PVRT_Exempt = Convert(Char(1), cci.PVRT_Exempt),
		GST_Include = Convert(Char(1), cci.GST_Included),
		PST_Include = Convert(Char(1), cci.PST_Included),
		PVRT_Include = Convert(Char(1), cci.PVRT_Included),
		Total_Qty = SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' then
											0
									Else
											cci.Quantity
									End
									),
		--Total_Amount = SUM(cci.Amount),
       Total_Amount = SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' then
											0
									Else
											cci.Amount
									End
									),
		Total_GST = SUM(cci.GST_Amount),
		Total_PST = SUM(cci.PST_Amount),
		Total_PVRT = SUM(cci.PVRT_Amount),
		oe.type
	FROM	Contract_Charge_Item CCI
		join contract c
						on c.contract_number = cci.contract_number
LEFT JOIN(SELECT     dbo.Vehicle_Rate.Rate_ID,  dbo.Vehicle_Rate.Rate_Name,dbo.Vehicle_Rate.Effective_Date, dbo.Vehicle_Rate.Termination_Date, dbo.Vehicle_Rate.Location_Fee_Included, 
                      dbo.Rate_Purpose.Rate_Purpose
					FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Purpose ON dbo.Vehicle_Rate.Rate_Purpose_ID = dbo.Rate_Purpose.Rate_Purpose_ID) vr
		on c.rate_id = vr.rate_id 
		and c.Rate_Assigned_Date between vr.effective_date and vr.termination_date
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Adjustment'
		left join (Select distinct  Contract_Number,Optional_Extra_ID,HST2_Exempt 
						from contract_optional_extra  
						Where	Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
								And   Rent_From<>Rent_To) coe
		on cci.contract_number=coe.contract_number 
			and cci.optional_extra_id=coe.optional_extra_id
		left join Optional_Extra oe on oe.Optional_Extra_ID=cci.Optional_Extra_ID 
	WHERE	cci.Contract_Number = @iContractNum
	AND	Charge_Item_Type = 'a'
	GROUP BY Contract_Billing_Party_ID, LT.Value, Unit_Type, PVRT_Days,
		cci.GST_Exempt, Convert(Char(1), cci.PST_Exempt),
		Convert(Char(1), cci.PVRT_Exempt), Convert(Char(1), cci.GST_Included),
		Convert(Char(1), cci.PST_Included),	Convert(Char(1), cci.PVRT_Included),coe.HST2_Exempt,oe.Type,unit_amount  --unit_amount for avoiding different item combine together.
	HAVING SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' then
											0
									Else
											cci.Amount
									End
									) + SUM(cci.GST_Amount) + SUM(cci.PST_Amount) + SUM(cci.PVRT_Amount) <> 0

	UNION ALL

	-- Get reimbursement charge items
	SELECT	Contract_Billing_Party_ID,
		LT.Value,
		Unit_Type,
		PVRT_Days,
		GST_Exempt = Convert(Char(1), GST_Exempt),
		PST_Exempt = Convert(Char(1), PST_Exempt),
		PVRT_Exempt = Convert(Char(1), PVRT_Exempt),
		GST_Include = Convert(Char(1), GST_Included),
		PST_Include = Convert(Char(1), PST_Included),
		PVRT_Include = Convert(Char(1), PVRT_Included),
		Total_Qty = SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' then
											0
									Else
											 Quantity
									End
									),
		Total_Amount = SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' then
											0
									Else
											 Amount
									End
									) ,
		Total_GST = SUM(GST_Amount),
		Total_PST = SUM(PST_Amount),
		Total_PVRT = SUM(PVRT_Amount),
		oe.type
	FROM	Contract_Charge_Item CCI
	join contract c
						on c.contract_number = cci.contract_number
	LEFT JOIN(SELECT     dbo.Vehicle_Rate.Rate_ID,  dbo.Vehicle_Rate.Rate_Name,dbo.Vehicle_Rate.Effective_Date, dbo.Vehicle_Rate.Termination_Date, dbo.Vehicle_Rate.Location_Fee_Included, 
                      dbo.Rate_Purpose.Rate_Purpose
					FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Purpose ON dbo.Vehicle_Rate.Rate_Purpose_ID = dbo.Rate_Purpose.Rate_Purpose_ID) vr
		on c.rate_id = vr.rate_id 
		and c.Rate_Assigned_Date between vr.effective_date and vr.termination_date
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Reimbursement'
		left join Optional_Extra oe on oe.Optional_Extra_ID=cci.Optional_Extra_ID 
	WHERE	cci.Contract_Number  = @iContractNum
	AND	Charge_Item_Type = 'r'
	GROUP BY Contract_Billing_Party_ID, LT.Value, Unit_Type, PVRT_Days,
		Convert(Char(1), GST_Exempt), Convert(Char(1), PST_Exempt),
		Convert(Char(1), PVRT_Exempt), Convert(Char(1), GST_Included),
		Convert(Char(1), PST_Included), Convert(Char(1), PVRT_Included),oe.type
	HAVING SUM(
									Case When vr.Rate_Purpose='Tour Pkg' And cci.Charge_Type = 10 And cci.Charge_Description='Vehicle Rental' then
											0
									Else
											 Amount
									End
									) + SUM(GST_Amount) + SUM(PST_Amount) + SUM(PVRT_Amount) <> 0

	UNION ALL

	-- Get reimbursements
	SELECT	-1 as Contract_Billing_Party_Id,
		Reimbursement_Reason as Item_Description,
		'Flat' as Unit_Type,
		0 as PVRT_Days,
		'1' as GST_Exempt,
		'1' as PST_Exempt,
		'1' as PVRT_Exempt,
		'0' as GST_Include,
		'0' as PST_Include,
		'0' as PVRT_Include,
		'1' as Total_Qty,
		Flat_Amount * -1 as Total_Amount,
		0 as Total_GST,
		0 as Total_PST,
		0 as Total_PVRT,
		'Other'
	FROM	Contract_Reimbur_And_Discount
	WHERE	Contract_Number = @iContractNum
	AND	Type = 'Reimbursement'

	ORDER BY 12 desc

	RETURN @@ROWCOUNT



GO
