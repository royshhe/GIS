USE [GISData]
GO
/****** Object:  View [dbo].[tmpVIEW2]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpVIEW2]
AS
SELECT     dbo.Vehicle.Unit_Number, dbo.Vehicle.Foreign_Vehicle_Unit_Number, dbo.Owning_Company.Name, dbo.Owning_Company.Address1, 
                      dbo.Owning_Company.Address2, dbo.Owning_Company.City, dbo.Owning_Company.Province, dbo.Owning_Company.Postal_Code, 
                      dbo.Owning_Company.Country, dbo.Owning_Company.Phone_Number
FROM         dbo.Vehicle INNER JOIN
                      dbo.Owning_Company ON dbo.Vehicle.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID
GO
