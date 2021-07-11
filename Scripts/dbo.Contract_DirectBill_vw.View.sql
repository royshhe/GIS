USE [GISData]
GO
/****** Object:  View [dbo].[Contract_DirectBill_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_DirectBill_vw]
AS
SELECT     CBP.Contract_Number, CBP.Customer_Code, AM.address_name AS DBName, DBPB.PO_Number
FROM         dbo.Contract_Billing_Party AS CBP INNER JOIN
                      dbo.Direct_Bill_Primary_Billing AS DBPB ON CBP.Contract_Billing_Party_ID = DBPB.Contract_Billing_Party_ID AND 
                      DBPB.Contract_Number = CBP.Contract_Number AND CBP.Billing_Type = 'p' AND CBP.Billing_Method = 'Direct Bill' INNER JOIN
                      dbo.armaster AS AM ON CBP.Customer_Code = AM.customer_code AND AM.address_type = 0

GO
