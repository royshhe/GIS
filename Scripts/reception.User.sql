USE [GISData]
GO
/****** Object:  User [reception]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [reception] WITH DEFAULT_SCHEMA=[reception]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [reception]
GO
