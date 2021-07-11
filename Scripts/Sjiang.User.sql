USE [GISData]
GO
/****** Object:  User [Sjiang]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [Sjiang] WITH DEFAULT_SCHEMA=[Sjiang]
GO
ALTER ROLE [Rate] ADD MEMBER [Sjiang]
GO
