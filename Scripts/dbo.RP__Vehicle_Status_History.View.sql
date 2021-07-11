USE [GISData]
GO
/****** Object:  View [dbo].[RP__Vehicle_Status_History]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP__Vehicle_Status_History]
AS
SELECT     dbo.Vehicle_History.Unit_Number, dbo.Lookup_Table.[Value] AS Status, dbo.Vehicle_History.Effective_On
FROM         dbo.Lookup_Table INNER JOIN
                      dbo.Vehicle_History ON dbo.Lookup_Table.Code = dbo.Vehicle_History.Vehicle_Status INNER JOIN
                      dbo.Vehicle ON dbo.Vehicle_History.Unit_Number = dbo.Vehicle.Unit_Number
WHERE     (dbo.Lookup_Table.Category LIKE '%Vehicle Status%') AND (dbo.Vehicle.Owning_Company_ID = 7425)
GO
