USE [GISData]
GO
/****** Object:  User [BUDGETBC\Payrollassistant]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE USER [BUDGETBC\Payrollassistant] FOR LOGIN [BUDGETBC\Payrollassistant] WITH DEFAULT_SCHEMA=[BUDGETBC\Payrollassistant]
GO
ALTER ROLE [HR] ADD MEMBER [BUDGETBC\Payrollassistant]
GO
