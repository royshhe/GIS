USE [GISData]
GO
/****** Object:  View [dbo].[FA_Risk_Type_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[FA_Risk_Type_vw]
AS
SELECT   code, Value 
FROM         dbo.Lookup_Table
WHERE     (Category = 'Risk Type')

GO
