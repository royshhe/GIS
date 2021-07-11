USE [GISData]
GO
/****** Object:  User [vfung]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [vfung] FOR LOGIN [BUDGETBC\vfung] WITH DEFAULT_SCHEMA=[vfung]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [vfung]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [vfung]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [vfung]
GO
ALTER ROLE [db_datareader] ADD MEMBER [vfung]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [vfung]
GO
ALTER ROLE [ReportRole] ADD MEMBER [vfung]
GO
ALTER ROLE [WebAppUserRole] ADD MEMBER [vfung]
GO
ALTER ROLE [InterBranch] ADD MEMBER [vfung]
GO
ALTER ROLE [FleetAccounting] ADD MEMBER [vfung]
GO
ALTER ROLE [Rate] ADD MEMBER [vfung]
GO
ALTER ROLE [OnlineUserRole] ADD MEMBER [vfung]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [vfung]
GO
ALTER ROLE [CSRIncentive] ADD MEMBER [vfung]
GO
ALTER ROLE [HR] ADD MEMBER [vfung]
GO
ALTER ROLE [PM] ADD MEMBER [vfung]
GO
ALTER ROLE [OptionalExtra] ADD MEMBER [vfung]
GO
ALTER ROLE [Claims] ADD MEMBER [vfung]
GO
ALTER ROLE [GISUserManagement] ADD MEMBER [vfung]
GO
ALTER ROLE [db_executer] ADD MEMBER [vfung]
GO
