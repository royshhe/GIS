USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_21_IBDueTo_Matching]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[RP_SP_Acc_21_IBDueTo_Matching] --'2008-01-01', '2008-01-10'
(
	@vendorNo varchar(20) = ''	
)
AS
-- convert strings to datetime


SELECT    -- dbo.IB_apapay.Vender_No,  
                  dbo.IB_apapay.Doc_Number,  dbo.IB_apapay.Due_Date, 
                  dbo.IB_apapay.Payables, 
                  --dbo.IB_Vouchers.Vendor_No Stmt_Vendor_No,  
                  dbo.IB_Vouchers.Due_Date Stmt_Due_Date, dbo.IB_Vouchers.Foreign_Num, 
                  dbo.IB_Vouchers.Contract_Number, 
                  dbo.IB_Vouchers.Due_Amount
FROM        dbo.IB_apapay Full outer JOIN
                   dbo.IB_Vouchers ON dbo.ConvertToCtrctNumber(dbo.IB_apapay.Doc_Number, 'c', 'i') = CONVERT(int, dbo.IB_Vouchers.Contract_Number)
--where dbo.IB_apapay.Vender_No=@vendorNo or  dbo.IB_Vouchers.Vendor_No =@vendorNo 

GO
