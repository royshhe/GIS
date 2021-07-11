USE [GISData]
GO
/****** Object:  View [dbo].[tmpDecal]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpDecal]
AS
SELECT DISTINCT 
                      dbo.Decal.Unit#, dbo.Decal.Serial_Number, dbo.Decal.Model, dbo.Decal.Ext_Color, dbo.Decal.[Year], dbo.Decal.KM, dbo.Decal.Transfer_Date, 
                      dbo.Decal.Status, dbo.Decal.Days_in_service, dbo.Decal.Location, dbo.Decal.Licence, voc.PickupLoc, voc.DropOffLoc, voc.Checked_Out, 
                      voc.Expected_Check_In, voc.Contract_Number, dbo.Location.Location AS CurrentLocation, voc.Actual_Drop_Off_Location_ID
FROM         dbo.Vehicle INNER JOIN
                      dbo.Decal ON dbo.Vehicle.Unit_Number = dbo.Decal.Unit# INNER JOIN
                      dbo.Location ON dbo.Vehicle.Current_Location_ID = dbo.Location.Location_ID LEFT OUTER JOIN
                          (SELECT DISTINCT 
                                                   dbo.Vehicle_On_Contract.Unit_Number, PickUPLocation.Location AS PickupLoc, DropOffLoc.Location AS DropOffLoc, 
                                                   dbo.Vehicle_On_Contract.Checked_Out, dbo.Vehicle_On_Contract.Expected_Check_In, dbo.Vehicle_On_Contract.Contract_Number, 
                                                   dbo.Vehicle_On_Contract.Actual_Drop_Off_Location_ID
                            FROM          dbo.Location PickUPLocation INNER JOIN
                                                   dbo.Vehicle_On_Contract ON PickUPLocation.Location_ID = dbo.Vehicle_On_Contract.Pick_Up_Location_ID INNER JOIN
                                                   dbo.Contract ON dbo.Vehicle_On_Contract.Contract_Number = dbo.Contract.Contract_Number INNER JOIN
                                                   dbo.Location DropOffLoc ON dbo.Vehicle_On_Contract.Expected_Drop_Off_Location_ID = DropOffLoc.Location_ID
                            WHERE      (dbo.Contract.Status = 'CO')) voc ON dbo.Vehicle.Unit_Number = voc.Unit_Number
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[21] 2[23] 3) )"
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
         Begin Table = "Decal"
            Begin Extent = 
               Top = 35
               Left = 209
               Bottom = 296
               Right = 367
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle"
            Begin Extent = 
               Top = 44
               Left = 475
               Bottom = 283
               Right = 706
            End
            DisplayFlags = 280
            TopColumn = 29
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 183
               Left = 988
               Bottom = 291
               Right = 1229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "voc"
            Begin Extent = 
               Top = 6
               Left = 744
               Bottom = 114
               Right = 968
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
      Begin ColumnWidths = 19
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
         Table = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpDecal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpDecal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpDecal'
GO
