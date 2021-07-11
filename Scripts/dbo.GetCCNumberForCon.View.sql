USE [GISData]
GO
/****** Object:  View [dbo].[GetCCNumberForCon]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[GetCCNumberForCon] as

select con.Contract_number, cc.Credit_card_number from contract con
left Join  Renter_Primary_Billing RPB
		  On con.Contract_Number = RPB.Contract_Number
Left Join Credit_Card CC
		  On RPB.Credit_Card_Key = CC.Credit_Card_Key	
	Where con.contract_number in (1622841)	  
		  
GO
