USE [GISData]
GO
/****** Object:  View [dbo].[IB_Rental_Commision_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[IB_Rental_Commision_vw]
AS

SELECT     ARHeader.Contract_Number, SUM(ARDet.Amount) AS CommissionAount, 'Due From' as CommissionType--, GLAccount.account_description
FROM         dbo.IB_AR_Header AS ARHeader INNER JOIN
                      dbo.IB_AR_Detail AS ARDet ON ARHeader.IB_AR_ID = ARDet.IB_AR_ID INNER JOIN
                      dbo.IB_Revenue_Accounts AS GLAccount ON ARDet.Revenue_Account = GLAccount.GL_Revenue_Account
 WHERE     (GLAccount.account_description  not IN ('GASOLINE REV', 'GASOLINE FPO'))
GROUP BY ARHeader.Contract_Number --, GLAccount.account_description

Union


SELECT     APHead.Contract_Number, sum(APDet.Amount) as CommissionAmount, 'Due To'
FROM         dbo.IB_AP_Detail AS APDet INNER JOIN
                      dbo.IB_AP_Header AS APHead ON APDet.IB_AP_ID = APHead.IB_AP_ID INNER JOIN
                      dbo.IB_Revenue_Accounts AS GLAccount ON APDet.Expense_Account = GLAccount.GL_Revenue_Account
WHERE     (GLAccount.account_description  not IN ('GASOLINE REV', 'GASOLINE FPO'))
GROUP BY  APHead.Contract_Number
GO
