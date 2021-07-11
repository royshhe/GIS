USE [GISData]
GO
/****** Object:  View [dbo].[RP__Reservation_Make_Time]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[RP__Reservation_Make_Time]
AS
--SELECT     Confirmation_Number, MIN(Changed_On) AS ResMadeTime
--FROM         dbo.Reservation_Change_History
--GROUP BY Confirmation_Number




SELECT RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResMadeTime
from 
(

	SELECT     Confirmation_Number, Changed_On
	FROM         dbo.Reservation_Change_History
	union 

	SELECT  Confirmation_Number, dateadd(hour, -3, Transaction_Date) Changed_On
	FROM  dbo.Maestro
) RCH
GROUP BY RCH.Confirmation_Number

				
				
				


--SELECT     RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResMadeTime
--from 
--(

--	SELECT     Confirmation_Number, Changed_On
--	FROM         dbo.Reservation_Change_History
--	union 

--	SELECT  Confirmation_Number, Transaction_Date Changed_On
--	FROM  dbo.Maestro
--) RCH
--GROUP BY RCH.Confirmation_Number





GO
