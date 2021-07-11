USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractKmDriven]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewContractKmDriven]
AS
SELECT     dbo.Contract.Contract_Number, SUM(dbo.Vehicle_On_Contract.Km_In - dbo.Vehicle_On_Contract.Km_Out) AS KmDriven
FROM         dbo.Contract INNER JOIN
                      dbo.Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.Vehicle_On_Contract.Contract_Number
GROUP BY dbo.Contract.Contract_Number
GO
