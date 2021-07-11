USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_GetLastInterimBillingDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetInterimBillData    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetInterimBillData    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[ITB_GetLastInterimBillingDate]-- 1739774
@ContractNumber varchar(35)
AS
	/* 3/26/99 - cpy bug fix - sort result by ascending bill date */


Select	top 1
	Interim_Bill.Interim_Bill_Date
From
	Contract_Payment_Item
		INNER JOIN
		  AR_Payment ON
		    Contract_Payment_Item.Contract_Number = AR_Payment.Contract_Number
		    And Contract_Payment_Item.Sequence = AR_Payment.Sequence
		  RIGHT OUTER JOIN
		      Interim_Bill ON
		        AR_Payment.Contract_Number = Interim_Bill.Contract_Number
			And AR_Payment.Contract_Billing_Party_ID = Interim_Bill.Contract_Billing_Party_ID
			And AR_Payment.Interim_Bill_Date = Interim_Bill.Interim_Bill_Date
Where
	Interim_Bill.Contract_Number = Convert(int,@ContractNumber) and amount is not null
	and (isnull(Interim_Bill.void,0)<>1 )
ORDER BY Interim_Bill.Interim_Bill_Date desc


Return 1


GO
