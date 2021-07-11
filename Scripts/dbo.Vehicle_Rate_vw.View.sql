USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Rate_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vehicle_Rate_vw]
AS
SELECT     dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Rate.Rate_Name, 65 AS Rate_Level_ID, dbo.Rate_Charge_Amount.Rate_Level, 
                      dbo.Rate_Time_Period.Time_Period, dbo.Rate_Time_Period.Time_Period_Start, dbo.Rate_Time_Period.Time_period_End, 
                      dbo.Rate_Time_Period.Type, dbo.Rate_Charge_Amount.Amount, dbo.Rate_Vehicle_Class.Per_KM_Charge
FROM         dbo.Rate_Charge_Amount INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Rate_Charge_Amount.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Rate_Vehicle_Class ON dbo.Rate_Charge_Amount.Rate_Vehicle_Class_ID = dbo.Rate_Vehicle_Class.Rate_Vehicle_Class_ID AND 
                      dbo.Rate_Charge_Amount.Rate_ID = dbo.Rate_Vehicle_Class.Rate_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Rate_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Rate_Time_Period ON dbo.Rate_Charge_Amount.Rate_Time_Period_ID = dbo.Rate_Time_Period.Rate_Time_Period_ID AND 
                      dbo.Rate_Charge_Amount.Rate_ID = dbo.Rate_Time_Period.Rate_ID
WHERE     (dbo.Vehicle_Rate.Termination_Date > GETDATE()) AND (dbo.Rate_Charge_Amount.Termination_Date > GETDATE()) AND 
                      (dbo.Rate_Vehicle_Class.Termination_Date > GETDATE()) AND (dbo.Rate_Time_Period.Termination_Date > GETDATE()) AND 
                      (dbo.Vehicle_Rate.Rate_Name LIKE 'ahi%' OR
                      dbo.Vehicle_Rate.Rate_Name LIKE 'afi%' OR
                      dbo.Vehicle_Rate.Rate_Name LIKE 'aei%') AND (dbo.Rate_Charge_Amount.Rate_Level = 'A')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[31] 3) )"
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
         Begin Table = "Rate_Charge_Amount"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Rate"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Rate_Vehicle_Class"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 114
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Rate_Time_Period"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 222
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
   Begin CriteriaPane =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vehicle_Rate_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vehicle_Rate_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vehicle_Rate_vw'
GO
