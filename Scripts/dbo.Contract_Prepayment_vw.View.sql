USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Prepayment_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Prepayment_vw]
AS
SELECT     dbo.Prepayment.Contract_Number, dbo.Prepayment.Payment_Type, dbo.Prepayment.Currency_ID, dbo.Prepayment.Exchange_Rate, 
                      SUM(dbo.Prepayment.Foreign_Currency_Amt_Collected) AS Foreign_Currency_Amt_Collected,  Business_Transaction.RBR_Date
--select *
FROM         dbo.Prepayment INNER JOIN
                      dbo.Contract_Payment_Item ON dbo.Prepayment.Contract_Number = dbo.Contract_Payment_Item.Contract_Number AND 
                      dbo.Prepayment.Sequence = dbo.Contract_Payment_Item.Sequence AND dbo.Prepayment.Payment_Type = dbo.Contract_Payment_Item.Payment_Type
					inner join contract con on con.contract_number= dbo.Prepayment.Contract_Number
					inner join Business_Transaction  WITH(NOLOCK) ON Business_Transaction.Contract_Number =con.Contract_Number
where  Business_Transaction.Transaction_Description='check in' 
--		and issuer_id not in (select CUSTOMER_CODE
--									From armaster
--									where price_code='TOUR' AND ADDRESS_NAME LIKE '%EXPEDIA%'
--									AND Address_Type = 0	And Status_Type = 1)
GROUP BY dbo.Prepayment.Contract_Number, dbo.Prepayment.Payment_Type, dbo.Prepayment.Currency_ID, dbo.Prepayment.Exchange_Rate, 
                       Business_Transaction.RBR_Date
GO
