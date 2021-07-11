USE [GISData]
GO
/****** Object:  View [dbo].[tmpCCRSTempReport]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpCCRSTempReport]
AS
SELECT     dbo.ViewCCRSMain.ContractNum, dbo.ViewCCRSMain.First_Name + ' ' + dbo.ViewCCRSMain.Last_Name AS Customer_name, dbo.ViewCCRSMain.BCN,
                       dbo.ViewCCRSMain.dateOut, dbo.ViewCCRSMain.DateIN, dbo.ViewCCRSMain.PickupLocation, dbo.ViewCCRSMain.DropOffLocation, 
                      dbo.ViewCCRSMain.TnM, dbo.ViewContractRevenueSum.TotalRevenue AS TotalCharges, dbo.ViewCCRSMain.IATA_Number, 
                      dbo.ViewCCRSMain.ReservatinNumber, dbo.ViewCCRSMain.VehicleSIPPCode, dbo.ViewCCRSMain.MilesDriven, 
                      dbo.ViewContractRevenueSum.rate_name
FROM         dbo.ViewCCRSMain INNER JOIN
                      dbo.ViewContractRevenueSum ON dbo.ViewCCRSMain.ContractNum = dbo.ViewContractRevenueSum.Contract_Number
WHERE     (dbo.ViewCCRSMain.RBR_Date >= '2006-02-01') AND (dbo.ViewCCRSMain.RBR_Date < '2006-03-01')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ViewCCRSMain"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 351
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 64
         End
         Begin Table = "ViewContractRevenueSum"
            Begin Extent = 
               Top = 6
               Left = 273
               Bottom = 321
               Right = 462
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpCCRSTempReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpCCRSTempReport'
GO
