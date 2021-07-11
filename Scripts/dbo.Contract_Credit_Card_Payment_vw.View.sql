USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Credit_Card_Payment_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Credit_Card_Payment_vw]
AS
SELECT     dbo.Contract_Payment_Item.Contract_Number, dbo.Credit_Card_Type.Credit_Card_Type, sum(dbo.Contract_Payment_Item.Amount) as Amount, 
                      dbo.Contract_Payment_Item.RBR_Date
FROM         dbo.Contract_Payment_Item INNER JOIN
                      dbo.Credit_Card_Payment ON dbo.Contract_Payment_Item.Contract_Number = dbo.Credit_Card_Payment.Contract_Number AND 
                      dbo.Contract_Payment_Item.Sequence = dbo.Credit_Card_Payment.Sequence INNER JOIN
                      dbo.Credit_Card ON dbo.Credit_Card_Payment.Credit_Card_Key = dbo.Credit_Card.Credit_Card_Key INNER JOIN
                      dbo.Credit_Card_Type ON dbo.Credit_Card.Credit_Card_Type_ID = dbo.Credit_Card_Type.Credit_Card_Type_ID
						inner join contract con on con.contract_number=dbo.Contract_Payment_Item.Contract_Number
where con.status='CI'
group by  dbo.Contract_Payment_Item.Contract_Number, dbo.Credit_Card_Type.Credit_Card_Type, 
                      dbo.Contract_Payment_Item.RBR_Date
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[58] 4[3] 2[20] 3) )"
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
         Top = -34
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Contract_Payment_Item"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 216
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Credit_Card_Payment"
            Begin Extent = 
               Top = 6
               Left = 289
               Bottom = 125
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Credit_Card"
            Begin Extent = 
               Top = 63
               Left = 528
               Bottom = 182
               Right = 722
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Credit_Card_Type"
            Begin Extent = 
               Top = 216
               Left = 38
               Bottom = 335
               Right = 270
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
         Output = 1035
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Credit_Card_Payment_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Credit_Card_Payment_vw'
GO
