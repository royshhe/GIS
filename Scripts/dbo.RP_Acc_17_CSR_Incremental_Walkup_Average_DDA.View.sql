USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_17_CSR_Incremental_Walkup_Average_DDA]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Acc_17_CSR_Incremental_Walkup_Average_DDA]
AS
SELECT     Location_ID, RBR_date, SUM(Walkup_TnM) / (CASE WHEN SUM(Walkup_Rental_Days) > 0 THEN SUM(Walkup_Rental_Days) ELSE 1 END) 
                      AS Average_WalkUp_DDA
FROM         dbo.RP_ACC_17_CSR_Incremental_Incentive_Revenue
GROUP BY Location_ID, RBR_date


GO
