USE [GISData]
GO
/****** Object:  User [sj]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [sj] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[sj]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [sj]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [sj]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [sj]
GO
ALTER ROLE [db_datareader] ADD MEMBER [sj]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [sj]
GO
