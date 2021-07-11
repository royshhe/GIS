USE [GISData]
GO
/****** Object:  View [dbo].[RP__Reservation_Cancel_Time]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP__Reservation_Cancel_Time]
AS
SELECT     Confirmation_Number, Changed_On AS ResCancelTime
FROM         dbo.Reservation_Change_History
WHERE     (Status = 'c')


--SELECT RCH.Confirmation_Number, MIN(RCH.Changed_On) AS ResCancelTime
--from 
--(

--	SELECT     Confirmation_Number, Changed_On
--	FROM         dbo.Reservation_Change_History
--	WHERE     (Status = 'c')
--	union 

--	SELECT  Confirmation_Number, dateadd(hour, -3, Transaction_Date) Changed_On
--	FROM  dbo.Maestro
--	where maestro_data like '/ACTXL%'
--) RCH
--GROUP BY RCH.Confirmation_Number



GO
