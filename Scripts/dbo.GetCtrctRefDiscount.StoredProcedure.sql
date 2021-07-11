USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctRefDiscount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*  
PURPOSE: To retrieve discount or reimbursement info for the given contract number..
	 If VSISeq is not provided, then retrieve discount/reimbursement details:
		- if Discount type, return discount reason
		- if Reimbursement type, return reimbursement reason
	 If VSISeq is provided, then retrieve discount/reimbursement details 
	 that are linked to that Vehicle Support Incident
		- if Discount type, return discount reason
		- if Reimbursement type, return reimbursement reason
MOD HISTORY:
Name    Date		Comments
Don K	Mar 24 2000	Removed unnecessary distincts
*/
CREATE PROCEDURE [dbo].[GetCtrctRefDiscount]
	@ContractNumber VarChar(10),
	@Type 		VarChar(35), -- 'Discount' or 'Reimbursement'
	@VSISeq		VarChar(10) = Null
AS
	/* 4/10/99 - cpy bug fix - format Entered_On date to display in "dd mmm yyyy hh:mm" only */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE	@nContractNumber Integer
	SELECT	@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))

	SELECT	@VSISeq = NULLIF(@VSISeq,'')

  If @VSISeq IS Null
	Begin
		If @Type = 'Discount'
			Begin
				SELECT	Flat_Amount,
					Percentage,
					Discount_Reason,
					Entered_By,
					CONVERT(VarChar(17), Entered_On, 113) Entered_On
	
				FROM	Contract_Reimbur_And_Discount
				WHERE	Contract_Number = @nContractNumber
				AND	Type = @Type
			End
		Else
			Begin
				SELECT	Flat_Amount,
					Percentage,
					Reimbursement_Reason,
					Entered_By,
					CONVERT(VarChar(17), Entered_On, 113) Entered_On
	
				FROM	Contract_Reimbur_And_Discount
				WHERE	Contract_Number = @nContractNumber
				AND	Type = @Type
			End
	End		
  Else
	Begin
		If @Type = 'Discount'
			Begin
				SELECT	Flat_Amount,
					Percentage,
					Discount_Reason,
					Entered_By,
					CONVERT(VarChar(17), Entered_On, 113) Entered_On
	
				FROM	Contract_Reimbur_And_Discount
				WHERE	Contract_Number = @nContractNumber
				AND	Type = @Type
				AND	Vehicle_Support_Incident_Seq = CONVERT(Int, @VSISeq)
			End
		Else
			Begin
				SELECT	Flat_Amount,
					Percentage,
					Reimbursement_Reason,
					Entered_By,
					CONVERT(VarChar(17), Entered_On, 113) Entered_On
	
				FROM	Contract_Reimbur_And_Discount
				WHERE	Contract_Number = @nContractNumber
				AND	Type = @Type
				AND	Vehicle_Support_Incident_Seq = CONVERT(Int, @VSISeq)
			End
	End

RETURN @@ROWCOUNT

GO
