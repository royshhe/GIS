USE [GISData]
GO
/****** Object:  User [mau]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [mau] FOR LOGIN [BUDGETBC\Mau] WITH DEFAULT_SCHEMA=[mau]
GO
ALTER ROLE [HR] ADD MEMBER [mau]
GO
