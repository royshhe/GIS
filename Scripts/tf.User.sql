USE [GISData]
GO
/****** Object:  User [tf]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [tf] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[tf]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [tf]
GO
