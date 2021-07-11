USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCByContractNum]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCCByContractNum    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.GetCCByContractNum    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCCByContractNum    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCCByContractNum    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve credit card info for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCCByContractNum]
@ContractNumber varchar(35)
AS
-- DK 19990309 added Sequence_num

Select
	CC.Credit_Card_Type_ID, CC.Credit_Card_Number,
	CC.Expiry, CC.Last_Name, CC.First_Name, CC.Sequence_Num,cc.Short_Token
From
	Renter_Primary_Billing RPB, Credit_Card CC
Where
	RPB.Contract_Number = Convert(int, @ContractNumber)
	And Contract_Billing_Party_ID = -1
	And RPB.Credit_Card_Key = CC.Credit_Card_Key
Return 1
GO
