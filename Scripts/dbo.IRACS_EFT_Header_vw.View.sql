USE [GISData]
GO
/****** Object:  View [dbo].[IRACS_EFT_Header_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IRACS_EFT_Header_vw]
AS
SELECT     dbo.Location.CounterCode, dbo.Contract.Contract_Number, dbo.RP__CSR_Who_Opened_The_Contract.Transaction_Date, 
                      dbo.Business_Transaction.RBR_Date
FROM         dbo.Contract INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.RP__CSR_Who_Opened_The_Contract ON 
                      dbo.Contract.Contract_Number = dbo.RP__CSR_Who_Opened_The_Contract.Contract_Number INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number
WHERE     (dbo.Business_Transaction.Transaction_Type = 'con') AND (dbo.Business_Transaction.Transaction_Description = 'check in')
                  and dbo.Location.Owning_Company_ID in (select Code from lookup_table where Category ='BudgetBC Company')





GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[63] 4[3] 2[12] 3) )"
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
         Begin Table = "Contract"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 331
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 244
               Left = 327
               Bottom = 352
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 44
         End
         Begin Table = "RP__CSR_Who_Opened_The_Contract"
            Begin Extent = 
               Top = 264
               Left = 812
               Bottom = 393
               Right = 1035
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Business_Transaction"
            Begin Extent = 
               Top = 19
               Left = 701
               Bottom = 246
               Right = 901
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 6945
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IRACS_EFT_Header_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IRACS_EFT_Header_vw'
GO
