USE [GISData]
GO
/****** Object:  View [dbo].[Organization_Rate_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Organization_Rate_vw]
AS
SELECT DISTINCT 
                      dbo.Organization.Organization, dbo.Organization.BCD_Number, dbo.Vehicle_Rate.Rate_Name, dbo.Organization_Rate.Rate_Level, 
                      dbo.Organization_Rate.Valid_From, dbo.Organization_Rate.Valid_To, dbo.Organization_Rate.Termination_Date
FROM         dbo.Organization_Rate INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Organization_Rate.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Organization ON dbo.Organization_Rate.Organization_ID = dbo.Organization.Organization_ID
WHERE     (dbo.Organization_Rate.Termination_Date > GETDATE()) AND (dbo.Vehicle_Rate.Termination_Date > GETDATE()) AND 
                      (dbo.Organization.BCD_Number = 'A571600')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[11] 2[20] 3) )"
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
         Begin Table = "Organization_Rate"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 189
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Rate"
            Begin Extent = 
               Top = 202
               Left = 598
               Bottom = 418
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Organization"
            Begin Extent = 
               Top = 6
               Left = 706
               Bottom = 163
               Right = 936
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
      Begin ColumnWidths = 8
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1935
         Width = 2850
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
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Organization_Rate_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Organization_Rate_vw'
GO
