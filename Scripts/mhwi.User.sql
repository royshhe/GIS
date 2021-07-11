USE [GISData]
GO
/****** Object:  User [mhwi]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [mhwi] WITH DEFAULT_SCHEMA=[mhwi]
GO
ALTER ROLE [ar_fee_processer] ADD MEMBER [mhwi]
GO
