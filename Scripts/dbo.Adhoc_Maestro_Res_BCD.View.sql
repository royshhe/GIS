USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_Maestro_Res_BCD]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Adhoc_Maestro_Res_BCD]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Contract.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Pick_Up_On, 
                      dbo.Reservation.Drop_Off_On, DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) 
                      / 1440.0 AS Contract_Rental_Days, dbo.RP__Last_Vehicle_On_Contract.Km_In - dbo.RP__Last_Vehicle_On_Contract.Km_Out AS KmDriven, 
                      CASE WHEN (dbo.Contract.Confirmation_Number IS NOT NULL) THEN 0 ELSE 1 END AS Walk_Up, dbo.Contract_Charge_Item.Charge_Type, 
                      dbo.Contract_Charge_Item.Charge_Item_Type, dbo.Contract_Charge_Item.Optional_Extra_ID, dbo.Contract.Reservation_Revenue, 
                      dbo.Contract_Charge_Item.Amount - dbo.Contract_Charge_Item.GST_Amount_Included - dbo.Contract_Charge_Item.PST_Amount_Included - dbo.Contract_Charge_Item.PVRT_Amount_Included
                       AS Amount, dbo.Reservation.BCD_Number AS Maestro_BCD, dbo.Reservation.Status
FROM         dbo.Reservation INNER JOIN
                      dbo.Contract INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number ON 
                      dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number
WHERE     (dbo.Reservation.BCD_Number IS NOT NULL) AND (dbo.Reservation.Source_Code = 'Maestro')
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
               Top = 215
               Left = 293
               Bottom = 323
               Right = 512
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract"
            Begin Extent = 
               Top = 48
               Left = 723
               Bottom = 156
               Right = 938
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 19
               Left = 148
               Bottom = 127
               Right = 374
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 69
               Left = 1098
               Bottom = 177
               Right = 1337
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Adhoc_Maestro_Res_BCD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Adhoc_Maestro_Res_BCD'
GO
