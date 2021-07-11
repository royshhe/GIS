USE [GISData]
GO
/****** Object:  User [hwu]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [hwu] FOR LOGIN [BUDGETBC\hwu] WITH DEFAULT_SCHEMA=[hwu]
GO
ALTER ROLE [WebAppUserRole] ADD MEMBER [hwu]
GO
ALTER ROLE [Rate] ADD MEMBER [hwu]
GO
ALTER ROLE [OnlineUserRole] ADD MEMBER [hwu]
GO
ALTER ROLE [OptionalExtra] ADD MEMBER [hwu]
GO
