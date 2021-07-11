USE [GISData]
GO
/****** Object:  User [adminstaff]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [adminstaff] FOR LOGIN [BUDGETBC\adminstaff] WITH DEFAULT_SCHEMA=[adminstaff]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [adminstaff]
GO
ALTER ROLE [OptionalExtra] ADD MEMBER [adminstaff]
GO
