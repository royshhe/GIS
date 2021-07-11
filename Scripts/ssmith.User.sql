USE [GISData]
GO
/****** Object:  User [ssmith]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [ssmith] WITH DEFAULT_SCHEMA=[ssmith]
GO
ALTER ROLE [Rate] ADD MEMBER [ssmith]
GO
