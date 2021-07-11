USE [GISData]
GO
/****** Object:  User [RateAssistant]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [RateAssistant] FOR LOGIN [BUDGETBC\RateAssistant] WITH DEFAULT_SCHEMA=[RateAssistant]
GO
ALTER ROLE [Rate] ADD MEMBER [RateAssistant]
GO
ALTER ROLE [OnlineUserRole] ADD MEMBER [RateAssistant]
GO
