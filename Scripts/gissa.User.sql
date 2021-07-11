USE [GISData]
GO
/****** Object:  User [gissa]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [gissa] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[gissa]
GO
ALTER ROLE [GISUserManagement] ADD MEMBER [gissa]
GO
