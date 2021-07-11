USE [GISData]
GO
/****** Object:  User [sliu]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [sliu] FOR LOGIN [BUDGETBC\SLiu] WITH DEFAULT_SCHEMA=[sliu]
GO
ALTER ROLE [InterBranch] ADD MEMBER [sliu]
GO
ALTER ROLE [FleetAccounting] ADD MEMBER [sliu]
GO
ALTER ROLE [Rate] ADD MEMBER [sliu]
GO
ALTER ROLE [CSRIncentive] ADD MEMBER [sliu]
GO
