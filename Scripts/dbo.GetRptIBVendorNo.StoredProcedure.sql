USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptIBVendorNo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create  PROCEDURE [dbo].[GetRptIBVendorNo] 
 
AS  
 SELECT     Vendor_code, Owning_Company_ID
FROM         dbo.Owning_Company
  	ORDER  
     	BY Vendor_code
   



GO
