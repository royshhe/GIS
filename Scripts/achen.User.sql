USE [GISData]
GO
/****** Object:  User [achen]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [achen] FOR LOGIN [BUDGETBC\Achen] WITH DEFAULT_SCHEMA=[achen]
GO
ALTER ROLE [HR] ADD MEMBER [achen]
GO
