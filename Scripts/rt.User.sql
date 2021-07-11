USE [GISData]
GO
/****** Object:  User [rt]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [rt] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[rt]
GO
ALTER ROLE [Rate] ADD MEMBER [rt]
GO
