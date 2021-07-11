USE [GISData]
GO
/****** Object:  User [quickfield]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [quickfield] FOR LOGIN [BUDGETBC\quickfield] WITH DEFAULT_SCHEMA=[quickfield]
GO
ALTER ROLE [db_owner] ADD MEMBER [quickfield]
GO
