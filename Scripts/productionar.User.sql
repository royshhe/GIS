USE [GISData]
GO
/****** Object:  User [productionar]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [productionar] FOR LOGIN [BUDGETBC\ProductionAR] WITH DEFAULT_SCHEMA=[productionar]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [productionar]
GO
