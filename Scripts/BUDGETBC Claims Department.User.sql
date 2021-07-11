USE [GISData]
GO
/****** Object:  User [BUDGETBC\Claims Department]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [BUDGETBC\Claims Department] FOR LOGIN [BUDGETBC\Claims Department]
GO
ALTER ROLE [Claims] ADD MEMBER [BUDGETBC\Claims Department]
GO
