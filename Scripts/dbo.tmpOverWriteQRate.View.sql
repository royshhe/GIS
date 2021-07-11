USE [GISData]
GO
/****** Object:  View [dbo].[tmpOverWriteQRate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpOverWriteQRate]
AS
SELECT Quoted_Rate_ID, Confirmation_Number, Rate_ID, Rate_Level, BCD_Number
FROM  dbo.Reservation
WHERE (Quoted_Rate_ID IS NOT NULL) AND (Rate_ID IS NOT NULL) AND (Status = 'a')
GO
