USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteInterimBill]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.DeleteInterimBill    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.DeleteInterimBill    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: To delete record(s), which have not been billed, from Interim_Bill table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteInterimBill]
@ContractNumber varchar(20),@BillingDate varchar(24)
AS

Delete from Interim_Bill

where Contract_Number = Convert(int, @ContractNumber)
	and Interim_Bill_Date=convert(datetime,@BillingDate)
	And Interim_Bill_Date not in 
		(Select
			IB.Interim_Bill_Date
		From
			AR_Payment ARP, Interim_Bill IB
		Where
			IB.Contract_Number = Convert(int, @ContractNumber)
			And IB.Contract_Number = ARP.Contract_Number
			And IB.Contract_Billing_Party_ID = ARP.Contract_Billing_Party_ID
			And IB.Interim_Bill_Date = ARP.Interim_Bill_Date)

--Delete From
--	Interim_Bill
--Where
--	Contract_Number = Convert(int, @ContractNumber)
--	And Not Exists
--		(Select
--			IB.Contract_Number
--		From
--			AR_Payment ARP, Interim_Bill IB
--		Where
--			IB.Contract_Number = Convert(int, @ContractNumber)
--			And IB.Contract_Number = ARP.Contract_Number
--			And IB.Contract_Billing_Party_ID = ARP.Contract_Billing_Party_ID
--			And IB.Interim_Bill_Date = ARP.Interim_Bill_Date)
	
Return 1

GO
