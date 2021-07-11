USE [GISData]
GO
/****** Object:  User [GISReqRpt]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [GISReqRpt] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[GISReqRpt]
GO
ALTER ROLE [db_datareader] ADD MEMBER [GISReqRpt]
GO
ALTER ROLE [ReportRole] ADD MEMBER [GISReqRpt]
GO
