USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_25_Cert_Voucher_Submission_SB]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Acc_25_Cert_Voucher_Submission_SB]
AS
SELECT     dbo.Contract_Prepayment_vw.Contract_Number, dbo.Contract_Prepayment_vw.Payment_Type, dbo.Contract_Prepayment_vw.Currency_ID, 
                      dbo.Contract_Prepayment_vw.Exchange_Rate, dbo.Contract_TnM_vw.Amount, dbo.Contract_Prepayment_vw.Foreign_Currency_Amt_Collected, 
                      dbo.Contract_Prepayment_vw.RBR_Date
FROM         dbo.Contract_Prepayment_vw INNER JOIN
                      dbo.Contract_TnM_vw ON dbo.Contract_Prepayment_vw.Contract_Number = dbo.Contract_TnM_vw.Contract_Number
GO
