USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintBillingParties]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To return mapping of billing_party_id and billing party name for a contract
MOD HISTORY:
Name	Date        	Comments
CPY	6/24/99 	- return billing method (describes alternate billing type) 
CPY	12/13/99 	- return billing type 
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return AR customer
			info even if the direct bill org has been inactivated
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintBillingParties]
	@ContractNum Varchar(10)
AS
DECLARE @iContractNum Int


	SELECT @iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	-- Get billing parties for contract

	SELECT	Billed_To = CASE
			WHEN CBP.Billing_Type = 'p'
				AND CBP.Billing_Method = 'Direct Bill'
				THEN ARM.Address_Name
			WHEN CBP.Billing_Type = 'p'
				AND CBP.Billing_Method = 'Renter'
				THEN 'Renter'
			ELSE	-- alternate billing
				ARM.Address_Name
		END,
		CBP.Contract_Billing_Party_Id,
		CBP.Billing_Method, 
		CBP.Billing_Type
	FROM	Contract_Billing_Party CBP
		LEFT JOIN armaster ARM
		  ON CBP.Customer_Code = ARM.Customer_Code
		 AND ARM.Address_Type = 0	-- company name
		 --AND ARM.Status_Type = 1	-- active
	WHERE	CBP.Contract_Number = @iContractNum
	ORDER BY CBP.Contract_Billing_Party_Id

	RETURN @@ROWCOUNT

















GO
