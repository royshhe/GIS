USE [GISData]
GO
/****** Object:  View [dbo].[ViewResCreatedDate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewResCreatedDate]
AS
SELECT     Confirmation_Number, MIN(Changed_On) AS Created
FROM         dbo.Reservation_Change_History
GROUP BY Confirmation_Number


GO
