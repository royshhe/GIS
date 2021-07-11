USE [GISData]
GO
/****** Object:  User [svbvm057$]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [svbvm057$] FOR LOGIN [BUDGETBC\SVBVM057$] WITH DEFAULT_SCHEMA=[svbvm057$]
GO
ALTER ROLE [db_owner] ADD MEMBER [svbvm057$]
GO
