USE [GISData]
GO
/****** Object:  User [BHQ Employee Performance]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [BHQ Employee Performance] FOR LOGIN [BUDGETBC\BHQ Employee Performance]
GO
ALTER ROLE [HR] ADD MEMBER [BHQ Employee Performance]
GO
