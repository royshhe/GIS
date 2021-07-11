USE [GISData]
GO
/****** Object:  View [dbo].[RP_Adhoc_NoShowFee_Collected]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP_Adhoc_NoShowFee_Collected]
AS
SELECT     dbo.Business_Transaction.Transaction_Date, dbo.Sales_Journal.Amount, dbo.Sales_Journal.GL_Account, dbo.Sales_Journal.Sequence, 
                      dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.RP__Reservation_Make_Time.ResMadeTime, 
                      dbo.Reservation.Last_Name, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Reservation.Pick_Up_On
FROM         dbo.Business_Transaction INNER JOIN
                      dbo.Sales_Journal ON dbo.Business_Transaction.Business_Transaction_ID = dbo.Sales_Journal.Business_Transaction_ID INNER JOIN
                      dbo.Reservation ON dbo.Business_Transaction.Confirmation_Number = dbo.Reservation.Confirmation_Number INNER JOIN
                      dbo.RP__Reservation_Make_Time ON dbo.Reservation.Confirmation_Number = dbo.RP__Reservation_Make_Time.Confirmation_Number INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Business_Transaction.RBR_Date >= '2006-07-01') AND (dbo.Business_Transaction.RBR_Date < '2006-08-01') AND 
                      (dbo.Business_Transaction.Transaction_Description = 'no show')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[5] 2[19] 3) )"
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
         Begin Table = "Business_Transaction"
            Begin Extent = 
               Top = 26
               Left = 423
               Bottom = 277
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Sales_Journal"
            Begin Extent = 
               Top = 173
               Left = 807
               Bottom = 342
               Right = 1007
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 365
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Reservation_Make_Time"
            Begin Extent = 
               Top = 6
               Left = 1078
               Bottom = 144
               Right = 1262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 273
               Left = 325
               Bottom = 381
               Right = 555
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
      Begin ColumnWidths = 11
         Width = 284
         Width = 2055
         Width = 2460
         Width = 1440
         Width = 1440
         Width = 2235
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Adhoc_NoShowFee_Collected'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Adhoc_NoShowFee_Collected'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Adhoc_NoShowFee_Collected'
GO
