USE [GISData]
GO
/****** Object:  View [dbo].[tmp_Not_	InDecal]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmp_Not_	InDecal]
AS
SELECT     dbo.Vehicle.Unit_Number, dbo.Vehicle.Current_Licence_Plate, dbo.Vehicle.Current_Rental_Status, dbo.Vehicle_On_Contract.Contract_Number, 
                      dbo.Vehicle_On_Contract.Checked_Out, dbo.Vehicle_On_Contract.Expected_Check_In, dbo.Vehicle_On_Contract.Actual_Check_In, dbo.Contract.Status, 
                      dbo.Vehicle_On_Contract.Pick_Up_Location_ID, dbo.Vehicle_On_Contract.Expected_Drop_Off_Location_ID, 
                      dbo.Vehicle_On_Contract.Actual_Drop_Off_Location_ID
FROM         dbo.Contract INNER JOIN
                      dbo.Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.Vehicle_On_Contract.Contract_Number AND 
                      dbo.Contract.Status = 'CO' RIGHT OUTER JOIN
                      dbo.Vehicle ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number
WHERE     (dbo.Vehicle.Current_Vehicle_Status = 'd') AND (dbo.Vehicle.Deleted = 0) AND (dbo.Vehicle.Unit_Number NOT IN
                          (SELECT     unit#
                            FROM          decal)) AND (dbo.Vehicle.Owning_Company_ID = 7425)
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
         Begin Table = "Vehicle"
            Begin Extent = 
               Top = 0
               Left = 63
               Bottom = 359
               Right = 294
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "Vehicle_On_Contract"
            Begin Extent = 
               Top = 0
               Left = 486
               Bottom = 321
               Right = 725
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract"
            Begin Extent = 
               Top = 33
               Left = 968
               Bottom = 369
               Right = 1183
            End
            DisplayFlags = 280
            TopColumn = 42
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 12
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 2250
         Width = 2115
         Width = 2265
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
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmp_Not_	InDecal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmp_Not_	InDecal'
GO
