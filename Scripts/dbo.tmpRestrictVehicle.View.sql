USE [GISData]
GO
/****** Object:  View [dbo].[tmpRestrictVehicle]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpRestrictVehicle]
AS
SELECT DISTINCT 
                      dbo.Vehicle.Unit_Number, dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, dbo.Vehicle_Class.Vehicle_Class_Name, 
                      dbo.Vehicle.Comments, dbo.Lookup_Table.[Value] AS Vehicle_Status
FROM         dbo.Vehicle INNER JOIN
                      dbo.Vehicle_Location_Restriction ON dbo.Vehicle.Unit_Number = dbo.Vehicle_Location_Restriction.Unit_Number INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Lookup_Table ON dbo.Vehicle.Current_Vehicle_Status = dbo.Lookup_Table.Code
WHERE     (dbo.Vehicle.Current_Vehicle_Status < 'i') AND (dbo.Lookup_Table.Category LIKE '%vehicle Status%')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[14] 3) )"
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
         Begin Table = "Vehicle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 327
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 14
         End
         Begin Table = "Vehicle_Location_Restriction"
            Begin Extent = 
               Top = 2
               Left = 784
               Bottom = 136
               Right = 1037
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Model_Year"
            Begin Extent = 
               Top = 199
               Left = 485
               Bottom = 307
               Right = 663
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 210
               Left = 939
               Bottom = 318
               Right = 1169
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lookup_Table"
            Begin Extent = 
               Top = 145
               Left = 359
               Bottom = 253
               Right = 510
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
      Begin ColumnWidths = 7
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 2745
         Width = 3435
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpRestrictVehicle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Alias = 900
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpRestrictVehicle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpRestrictVehicle'
GO
