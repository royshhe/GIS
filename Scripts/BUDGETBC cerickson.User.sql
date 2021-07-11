USE [GISData]
GO
/****** Object:  User [BUDGETBC\cerickson]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [BUDGETBC\cerickson] FOR LOGIN [BUDGETBC\cerickson] WITH DEFAULT_SCHEMA=[BUDGETBC\cerickson]
GO
ALTER ROLE [OptionalExtra] ADD MEMBER [BUDGETBC\cerickson]
GO
