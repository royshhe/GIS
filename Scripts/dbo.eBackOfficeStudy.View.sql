USE [GISData]
GO
/****** Object:  View [dbo].[eBackOfficeStudy]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[eBackOfficeStudy]
AS
SELECT     ACM.customer_code, ACM.address_name, ISNULL(BACM.po_num_reqd_flag, 0) AS Expr1, ISNULL(BACM.claim_num_reqd_flag, 0) AS Expr2, 
                      ACM.credit_limit - ISNULL(ACustA.amt_balance, 0) - ACA.Daily_Contract_Total - ACA.Expected_Open_Contract_Charges AS Expr3, ACM.resale_num, 
                      ACM.attention_name, ACM.attention_phone, ACM.FaxNo, ACM.Address, ACM.city, ACM.state, ACM.postal_code, ACM.country, ACM.Comment
FROM         dbo.AR_Credit_Authorization ACA INNER JOIN
                      dbo.armaster ACM ON ACA.Customer_Code = ACM.customer_code LEFT OUTER JOIN
                      dbo.bgt_armaster BACM ON ACM.customer_code = BACM.customer_code AND ACM.address_type = BACM.address_type AND 
                      ACM.ship_to_code = BACM.ship_to_code LEFT OUTER JOIN
                      dbo.aractcus ACustA ON ACM.customer_code = ACustA.customer_code
WHERE     (ACM.address_type = 0) AND (ACM.status_type = 1) AND (SUBSTRING(ACM.price_code, 1, 3) = 'DBD')
GO
