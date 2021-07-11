USE [GISData]
GO
/****** Object:  User [pni]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [pni] FOR LOGIN [BUDGETBC\Pni] WITH DEFAULT_SCHEMA=[pni]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [pni]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [pni]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [pni]
GO
ALTER ROLE [db_datareader] ADD MEMBER [pni]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [pni]
GO
ALTER ROLE [ReportRole] ADD MEMBER [pni]
GO
ALTER ROLE [WebAppUserRole] ADD MEMBER [pni]
GO
ALTER ROLE [InterBranch] ADD MEMBER [pni]
GO
ALTER ROLE [FleetAccounting] ADD MEMBER [pni]
GO
ALTER ROLE [Rate] ADD MEMBER [pni]
GO
ALTER ROLE [OnlineUserRole] ADD MEMBER [pni]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [pni]
GO
ALTER ROLE [CSRIncentive] ADD MEMBER [pni]
GO
ALTER ROLE [HR] ADD MEMBER [pni]
GO
ALTER ROLE [PM] ADD MEMBER [pni]
GO
ALTER ROLE [OptionalExtra] ADD MEMBER [pni]
GO
ALTER ROLE [Claims] ADD MEMBER [pni]
GO
ALTER ROLE [GISUserManagement] ADD MEMBER [pni]
GO
