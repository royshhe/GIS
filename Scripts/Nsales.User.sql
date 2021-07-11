USE [GISData]
GO
/****** Object:  User [Nsales]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [Nsales] FOR LOGIN [BUDGETBC\NSales] WITH DEFAULT_SCHEMA=[Nsales]
GO
ALTER ROLE [HR] ADD MEMBER [Nsales]
GO
