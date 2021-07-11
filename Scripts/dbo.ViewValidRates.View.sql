USE [GISData]
GO
/****** Object:  View [dbo].[ViewValidRates]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewValidRates]
AS
SELECT     Rate_ID, Rate_Name
FROM         dbo.Vehicle_Rate
WHERE     (Termination_Date > GETDATE())

GO
