USE [GISData]
GO
/****** Object:  View [dbo].[tmpActiveResByRateName]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpActiveResByRateName]
AS
SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Vehicle_Rate.Rate_Name, dbo.Location.Location, 
                      dbo.Reservation.First_Name, dbo.Reservation.Last_Name, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Reservation.Pick_Up_On, 
                      dbo.Reservation.Drop_Off_On
FROM         dbo.Reservation INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Reservation.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Location ON dbo.Reservation.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.Vehicle_Rate.Effective_Date AND dbo.Vehicle_Rate.Termination_Date) AND 
                      (dbo.Vehicle_Rate.Rate_Name LIKE '%snbc06%') AND (dbo.Reservation.Status = 'a')
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
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 342
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Rate"
            Begin Extent = 
               Top = 69
               Left = 627
               Bottom = 408
               Right = 865
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 19
               Left = 378
               Bottom = 127
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 115
               Left = 317
               Bottom = 223
               Right = 547
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
      Begin ColumnWidths = 10
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
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpActiveResByRateName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpActiveResByRateName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpActiveResByRateName'
GO
