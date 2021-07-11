USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInterimBillData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.GetInterimBillData    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetInterimBillData    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetInterimBillData] 
@ContractNumber varchar(35)
AS
	/* 3/26/99 - cpy bug fix - sort result by ascending bill date */

Set Rowcount 2000

Select	
	Interim_Bill.Interim_Bill_Date as Old_Interim_Bill_Date,
	Interim_Bill.Interim_Bill_Date,
	Contract_Payment_Item.Amount,
	Interim_Bill.Current_Km
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
	Interim_Bill.Contract_Number = Convert(int,@ContractNumber)
ORDER BY Interim_Bill.Interim_Bill_Date asc


Return 1
GO
