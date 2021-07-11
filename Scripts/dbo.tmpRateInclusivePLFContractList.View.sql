USE [GISData]
GO
/****** Object:  View [dbo].[tmpRateInclusivePLFContractList]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpRateInclusivePLFContractList]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Contract.Confirmation_Number, dbo.Vehicle_Rate.Rate_Name, 
                      dbo.Business_Transaction.Transaction_Description
FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Contract ON dbo.Vehicle_Rate.Rate_ID = dbo.Contract.Rate_ID INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number
WHERE     (dbo.Vehicle_Rate.Location_Fee_Included = 1) AND (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.Vehicle_Rate.Effective_Date AND 
                      dbo.Vehicle_Rate.Termination_Date) AND (dbo.Business_Transaction.RBR_Date >= '2005-03-01 ') AND 
                      (dbo.Business_Transaction.RBR_Date < '2005-04-01 ') AND (dbo.Business_Transaction.Transaction_Description = 'Check In')
GO
