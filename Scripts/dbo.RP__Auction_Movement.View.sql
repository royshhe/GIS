USE [GISData]
GO
/****** Object:  View [dbo].[RP__Auction_Movement]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP__Auction_Movement]
AS
SELECT     Unit_Number, MAX(Movement_Out) AS Movement_out, MAX(Movement_In) AS Movement_In
FROM         dbo.Vehicle_Movement
WHERE     (Receiving_Location_ID = 117)
GROUP BY Unit_Number
GO
