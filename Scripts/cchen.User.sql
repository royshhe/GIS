USE [GISData]
GO
/****** Object:  User [cchen]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [cchen] FOR LOGIN [BUDGETBC\cchen] WITH DEFAULT_SCHEMA=[cchen]
GO
ALTER ROLE [HR] ADD MEMBER [cchen]
GO
