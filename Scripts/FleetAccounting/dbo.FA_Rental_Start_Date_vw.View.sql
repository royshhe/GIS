USE [GISData]
GO
/****** Object:  View [dbo].[FA_Rental_Start_Date_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[FA_Rental_Start_Date_vw]
AS
SELECT     Unit_Number, MIN(Checked_Out) AS ISD
FROM         dbo.Vehicle_On_Contract
GROUP BY Unit_Number

GO
