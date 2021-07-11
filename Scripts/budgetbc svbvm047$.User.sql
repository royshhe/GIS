USE [GISData]
GO
/****** Object:  User [budgetbc\svbvm047$]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [budgetbc\svbvm047$] FOR LOGIN [BUDGETBC\SVBVM047$] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [budgetbc\svbvm047$]
GO
