USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInterimBillPeriodNumber]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetInterimBillPeriodNumber    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.GetInterimBillPeriodNumber    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetInterimBillPeriodNumber]-- '1827442'
	@ContractNumber		VarChar(10)
AS
DECLARE	@nContractNumber Integer
SELECT	@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))

SELECT	IB.Interim_Bill_Date
FROM	Contract_Billing_Party CBP,
	Interim_Bill IB
WHERE	CBP.Contract_Number = @nContractNumber
AND	CBP.Billing_Type = 'p'	-- Primary
AND	CBP.Billing_Method = 'Direct Bill'
AND	CBP.Contract_Number = IB.Contract_Number
AND	CBP.Contract_Billing_Party_Id = IB.Contract_Billing_Party_Id
and (ib.void is null or ib.void=0)
ORDER BY
	IB.Interim_Bill_Date














GO
