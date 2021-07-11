USE [GISData]
GO
/****** Object:  User [ktani]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [ktani] FOR LOGIN [BUDGETBC\KTani] WITH DEFAULT_SCHEMA=[ktani]
GO
ALTER ROLE [Rate] ADD MEMBER [ktani]
GO
ALTER ROLE [CSRIncentive] ADD MEMBER [ktani]
GO
