USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Reimbur_Total_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Reimbur_Total_vw]
AS
SELECT Contract_Number, SUM(Flat_Amount) AS Amount
FROM  dbo.Contract_Reimbur_and_Discount
Where Type='Reimbursement' 
GROUP BY Contract_Number


GO
