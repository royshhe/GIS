USE [GISData]
GO
/****** Object:  User [BUDGETBC\jkwok]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [BUDGETBC\jkwok] FOR LOGIN [BUDGETBC\Jkwok] WITH DEFAULT_SCHEMA=[BUDGETBC\jkwok]
GO
ALTER ROLE [InterBranch] ADD MEMBER [BUDGETBC\jkwok]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [BUDGETBC\jkwok]
GO
ALTER ROLE [HR] ADD MEMBER [BUDGETBC\jkwok]
GO
