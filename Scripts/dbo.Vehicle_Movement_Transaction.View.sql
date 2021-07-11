USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Movement_Transaction]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[Vehicle_Movement_Transaction]
AS
SELECT     dbo.Vehicle_Movement.Unit_Number, dbo.Vehicle_Movement.Movement_Out as Date_out, dbo.Vehicle_Movement.Movement_In as Date_In
FROM         dbo.Vehicle_Movement
UNION

SELECT     dbo.Vehicle_On_Contract.Unit_Number, dbo.Vehicle_On_Contract.Checked_Out AS Date_out, dbo.Vehicle_On_Contract.Actual_Check_In AS Date_In
FROM         dbo.Vehicle_On_Contract INNER JOIN
                      dbo.Contract ON dbo.Vehicle_On_Contract.Contract_Number = dbo.Contract.Contract_Number
Where  dbo.Contract.Status not in ('VD', 'CA')

/*SELECT     dbo.Vehicle_On_Contract.Unit_Number, dbo.Vehicle_On_Contract.Checked_Out as Date_out, dbo.Vehicle_On_Contract.Actual_Check_In  as Date_In
FROM         dbo.Vehicle_On_Contract
*/







GO
