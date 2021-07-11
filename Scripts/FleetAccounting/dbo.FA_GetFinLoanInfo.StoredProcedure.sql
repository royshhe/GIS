USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetFinLoanInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FA_GetFinLoanInfo] -- 'RBC'
	@FinCode		VarChar(10)
	
AS
	

SELECT     Convert(VarChar(1), Loan_Include_Tax), Bank_GL_Account, AP_Vendor_Code,Setup_Fee
FROM       dbo.FA_Financial_Institution
where Fin_Code= @FinCode

GO
