USE [GISData]
GO
/****** Object:  User [Rfoley]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [Rfoley] FOR LOGIN [BUDGETBC\Rfoley] WITH DEFAULT_SCHEMA=[Rfoley]
GO
ALTER ROLE [HR] ADD MEMBER [Rfoley]
GO
