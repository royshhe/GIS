USE [GISData]
GO
/****** Object:  View [dbo].[tmpVehicleModelyear]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpVehicleModelyear]
AS
SELECT     dbo.Vehicle_Model_Year.Vehicle_Model_ID, dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Model_Year.Km_Per_Litre, dbo.Vehicle_Model_Year.Fuel_Tank_Size, 
                      dbo.Vehicle_Model_Year.ICBC_Class, dbo.Vehicle_Model_Year.Manufacturer_ID, dbo.Vehicle_Model_Year.PST_Rate, 
                      dbo.Vehicle_Model_Year.Diesel, dbo.Vehicle_Model_Year.Last_Updated_By, dbo.Vehicle_Model_Year.Last_Updated_On
FROM         dbo.Vehicle_Model_Year INNER JOIN
                      dbo.Vehicle_Class_Vehicle_Model_Yr ON 
                      dbo.Vehicle_Model_Year.Vehicle_Model_ID = dbo.Vehicle_Class_Vehicle_Model_Yr.Vehicle_Model_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle_Class_Vehicle_Model_Yr.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Vehicle_Model_Year.Foreign_Model_Only = 0) AND (dbo.Vehicle_Model_Year.Model_Year > '2003')
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
         Begin Table = "Vehicle_Model_Year"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 309
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 0
               Left = 661
               Bottom = 259
               Right = 891
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class_Vehicle_Model_Yr"
            Begin Extent = 
               Top = 71
               Left = 333
               Bottom = 180
               Right = 508
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
      Begin ColumnWidths = 13
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2565
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpVehicleModelyear'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpVehicleModelyear'
GO
