USE [GISData]
GO
/****** Object:  View [dbo].[ViewResCanceledDate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewResCanceledDate]
AS
SELECT     Confirmation_Number, Changed_On, Status
FROM         dbo.Reservation_Change_History
WHERE     (Status = 'c')

GO
