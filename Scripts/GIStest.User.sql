USE [GISData]
GO
/****** Object:  User [GIStest]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [GIStest] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[GIStest]
GO
ALTER ROLE [db_datareader] ADD MEMBER [GIStest]
GO
