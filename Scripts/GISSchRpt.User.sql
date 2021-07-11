USE [GISData]
GO
/****** Object:  User [GISSchRpt]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [GISSchRpt] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[GISSchRpt]
GO
ALTER ROLE [db_datareader] ADD MEMBER [GISSchRpt]
GO
ALTER ROLE [ReportRole] ADD MEMBER [GISSchRpt]
GO
