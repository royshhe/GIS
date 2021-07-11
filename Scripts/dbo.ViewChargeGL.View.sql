USE [GISData]
GO
/****** Object:  View [dbo].[ViewChargeGL]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewChargeGL]
AS
SELECT DISTINCT dbo.Charge_GL.Charge_Type_ID, dbo.Lookup_Table.[Value], dbo.Charge_GL.Vehicle_Type_ID, dbo.Charge_GL.GL_Revenue_Account
FROM         dbo.Lookup_Table INNER JOIN
                      dbo.Charge_GL ON dbo.Lookup_Table.Code = dbo.Charge_GL.Charge_Type_ID
WHERE     (dbo.Lookup_Table.Category LIKE 'charge type%')
GO
