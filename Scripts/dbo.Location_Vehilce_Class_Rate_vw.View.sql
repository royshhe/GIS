USE [GISData]
GO
/****** Object:  View [dbo].[Location_Vehilce_Class_Rate_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Location_Vehilce_Class_Rate_vw]
AS
SELECT     dbo.Location.Location, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Rate.Rate_Name, dbo.Location_Vehicle_Rate_Level.Rate_Level, 
                      dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type, '' AS RatePeriod, dbo.Location_Vehicle_Rate_Level.Valid_From, 
                      dbo.Location_Vehicle_Rate_Level.Valid_To, dbo.Location_Vehicle_Rate_Level.Rate_Selection_Type
FROM         dbo.Location_Vehicle_Rate_Level INNER JOIN
                      dbo.Location_Vehicle_Class ON dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Location_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Location_Vehicle_Rate_Level.Rate_ID = dbo.Vehicle_Rate.Rate_ID
WHERE     (dbo.Location_Vehicle_Rate_Level.Valid_From > GETDATE())
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
         Configuration = "(H (1 [50] 2 [25] 3))"
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
         Configuration = "(H (1[56] 4[18] 2) )"
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
         Begin Table = "Location_Vehicle_Rate_Level"
            Begin Extent = 
               Top = 187
               Left = 187
               Bottom = 304
               Right = 414
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Location_Vehicle_Class"
            Begin Extent = 
               Top = 22
               Left = 433
               Bottom = 139
               Right = 649
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 200
               Left = 720
               Bottom = 317
               Right = 959
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 3
               Left = 710
               Bottom = 120
               Right = 960
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Rate"
            Begin Extent = 
               Top = 9
               Left = 0
               Bottom = 126
               Right = 247
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
         Or' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Location_Vehilce_Class_Rate_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Location_Vehilce_Class_Rate_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Location_Vehilce_Class_Rate_vw'
GO
