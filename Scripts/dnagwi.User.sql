USE [GISData]
GO
/****** Object:  User [dnagwi]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [dnagwi] FOR LOGIN [BUDGETBC\dnagwi] WITH DEFAULT_SCHEMA=[dnagwi]
GO
ALTER ROLE [Rate] ADD MEMBER [dnagwi]
GO
ALTER ROLE [HR] ADD MEMBER [dnagwi]
GO
