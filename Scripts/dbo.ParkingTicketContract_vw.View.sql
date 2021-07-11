USE [GISData]
GO
/****** Object:  View [dbo].[ParkingTicketContract_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ParkingTicketContract_vw]
AS
SELECT     CONVERT(char(20), dbo.Contract.Contract_Number) AS [Contract Number], UPPER(SUBSTRING(dbo.Contract.Last_Name, 1, 1)) 
                      + SUBSTRING(dbo.Contract.Last_Name, 2, LEN(dbo.Contract.Last_Name) - 1) AS [Last Name], UPPER(SUBSTRING(dbo.Contract.First_Name, 1, 1)) 
                      + SUBSTRING(dbo.Contract.First_Name, 2, LEN(dbo.Contract.First_Name) - 1) AS [First Name], dbo.Contract.Gender, 
                      dbo.Contract.Address_1 AS [Address 1], dbo.Contract.Address_2 AS [Address 2], dbo.Contract.City, dbo.Contract.Province_State AS Province, 
                      dbo.Contract.Postal_Code AS [Postal Code], dbo.Lookup_Table.[Value] AS Country, dbo.Contract.Phone_Number AS [Phone Number]
FROM         dbo.Contract LEFT OUTER JOIN
                      dbo.Lookup_Table ON dbo.Contract.Country = dbo.Lookup_Table.Code AND dbo.Lookup_Table.Category = 'Country'
GO
