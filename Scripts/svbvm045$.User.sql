USE [GISData]
GO
/****** Object:  User [svbvm045$]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [svbvm045$] FOR LOGIN [BUDGETBC\SVBVM045$] WITH DEFAULT_SCHEMA=[svbvm045$]
GO
ALTER ROLE [db_owner] ADD MEMBER [svbvm045$]
GO
