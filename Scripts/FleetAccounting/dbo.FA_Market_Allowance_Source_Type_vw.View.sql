USE [GISData]
GO
/****** Object:  View [dbo].[FA_Market_Allowance_Source_Type_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create VIEW [dbo].[FA_Market_Allowance_Source_Type_vw]
AS
SELECT     Code, Value
FROM         dbo.Lookup_Table
WHERE     (Category = 'MarketAllowanceSource')

GO
