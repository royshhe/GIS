USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehicleSold]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[ViewVehicleSold]
AS
SELECT Unit_Number, MAX(Effective_On) AS [Sold Date]
FROM Vehicle_History WITH(NOLOCK)
WHERE vehicle_status = 'i'
GROUP BY Unit_Number




GO
