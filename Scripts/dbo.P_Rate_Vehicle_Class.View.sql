USE [GISData]
GO
/****** Object:  View [dbo].[P_Rate_Vehicle_Class]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Rate_Vehicle_Class]
AS
SELECT     Rate_Vehicle_Class_ID, Rate_ID, Effective_Date, Termination_Date, Vehicle_Class_Code, Per_KM_Charge
FROM         svbvm032.Geordydata.dbo.Rate_Vehicle_Class AS Rate_Vehicle_Class
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())


GO
