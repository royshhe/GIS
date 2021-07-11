USE [GISData]
GO
/****** Object:  View [dbo].[Charge_Types_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Charge_Types_vw]
AS
SELECT DISTINCT [Value], Code, Alias
FROM         dbo.Lookup_Table
WHERE     (Category LIKE 'Charge Type%')

GO
