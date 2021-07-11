USE [GISData]
GO
/****** Object:  View [dbo].[P_Rate_Availibility]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Rate_Availibility]
AS
SELECT     Rate_ID, Effective_Date, Termination_Date, Valid_From, Valid_To
FROM         svbvm032.Geordydata.dbo.Rate_Availability AS Rate_Availability
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())


GO
