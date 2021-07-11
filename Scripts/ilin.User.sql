USE [GISData]
GO
/****** Object:  User [ilin]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [ilin] FOR LOGIN [BUDGETBC\ilin] WITH DEFAULT_SCHEMA=[ilin]
GO
ALTER ROLE [FleetAccounting] ADD MEMBER [ilin]
GO
