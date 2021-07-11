USE [GISData]
GO
/****** Object:  View [dbo].[tmpGISvsBeanStream]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpGISvsBeanStream]
AS
SELECT     dbo.OM_CRTransReport.trn_id, dbo.Credit_Card_Transaction.Credit_Card_Number, dbo.Credit_Card_Transaction.Authorization_Number, 
                      dbo.OM_CRTransReport.trn_card_type, dbo.OM_CRTransReport.trn_amount, dbo.OM_CRTransReport.trn_type, dbo.OM_CRTransReport.RBR_Date, 
                      dbo.OM_CRTransReport.trn_response, dbo.Credit_Card_Transaction.Added_To_GIS, dbo.Credit_Card_Transaction.Contract_Number, 
                      dbo.Credit_Card_Transaction.Confirmation_Number
FROM         dbo.Credit_Card_Transaction RIGHT OUTER JOIN
                      dbo.OM_CRTransReport ON dbo.Credit_Card_Transaction.Trx_Receipt_Ref_Num = dbo.OM_CRTransReport.trn_id
WHERE     (dbo.OM_CRTransReport.trn_type <> 'PA') AND (dbo.OM_CRTransReport.trn_response = '1')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[12] 3) )"
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
         Begin Table = "Credit_Card_Transaction"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 359
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OM_CRTransReport"
            Begin Extent = 
               Top = 43
               Left = 551
               Bottom = 258
               Right = 727
            End
            DisplayFlags = 280
            TopColumn = 4
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
         Width = 1725
         Width = 1725
         Width = 1725
         Width = 1725
         Width = 1725
         Width = 1725
         Width = 1725
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
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpGISvsBeanStream'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpGISvsBeanStream'
GO
