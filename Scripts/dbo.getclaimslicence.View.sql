USE [GISData]
GO
/****** Object:  View [dbo].[getclaimslicence]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: getclaimslicence
PURPOSE: Select licence information based on contract number for CARS program

AUTHOR:	Junaid Ahmed
DATE CREATED: 2002 Feb 26
USED BY: Enter Vehicle Accident Screen

MOD HISTORY:
Name 		Date		Comments

*/


CREATE VIEW [dbo].[getclaimslicence]
AS
SELECT     renter.Licence_Number, renter.Contract_Number, nonrenter.Number, nonrenter.Contract_Number AS noncontract
FROM         dbo.Renter_Driver_Licence renter CROSS JOIN
                      dbo.Non_Driving_Renter_ID nonrenter




GO
