USE [GISData]
GO
/****** Object:  User [Backupexec]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [Backupexec] FOR LOGIN [BUDGETBC\BackupExec] WITH DEFAULT_SCHEMA=[Backupexec]
GO
ALTER ROLE [db_owner] ADD MEMBER [Backupexec]
GO
