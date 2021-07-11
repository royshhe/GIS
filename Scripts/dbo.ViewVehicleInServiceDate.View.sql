USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehicleInServiceDate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[ViewVehicleInServiceDate]
AS
SELECT MIN(Checked_Out) AS InService, Unit_Number
FROM Vehicle_On_Contract WITH(NOLOCK)
GROUP BY Unit_Number



GO
