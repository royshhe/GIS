USE [GISData]
GO
/****** Object:  User [dayaudit]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [dayaudit] FOR LOGIN [BUDGETBC\dayaudit] WITH DEFAULT_SCHEMA=[dayaudit]
GO
ALTER ROLE [HR] ADD MEMBER [dayaudit]
GO
ALTER ROLE [OptionalExtra] ADD MEMBER [dayaudit]
GO
