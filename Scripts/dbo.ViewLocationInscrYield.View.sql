USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationInscrYield]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewLocationInscrYield]
AS
SELECT     *
FROM         dbo.LocationInscrYield
WHERE     (TerminateDate > GETDATE())
GO
