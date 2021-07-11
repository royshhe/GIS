USE [GISData]
GO
/****** Object:  User [ezhu]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [ezhu] FOR LOGIN [BUDGETBC\ezhu] WITH DEFAULT_SCHEMA=[ezhu]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [ezhu]
GO
