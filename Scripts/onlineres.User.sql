USE [GISData]
GO
/****** Object:  User [onlineres]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [onlineres] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [OnlineUserRole] ADD MEMBER [onlineres]
GO
