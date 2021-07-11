USE [GISData]
GO
/****** Object:  View [dbo].[tmpGetContractGLRevenue]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpGetContractGLRevenue]
AS
SELECT     dbo.Contract_Charge_Item.Charge_description, dbo.Contract_Charge_Item.Amount, 
                      (CASE WHEN dbo.Optional_Extra_GL.GL_Revenue_Account IS NOT NULL 
                      THEN dbo.Optional_Extra_GL.GL_Revenue_Account ELSE dbo.Charge_GL.GL_Revenue_Account END) AS GL_number, 
                      (CASE WHEN glchart_Charge.account_description IS NOT NULL 
                      THEN glchart_Charge.account_description ELSE glchart_OptionalExtra.account_description END) AS account_description
FROM         dbo.Contract_Charge_Item LEFT OUTER JOIN
                      dbo.glchart_base glchart_OptionalExtra INNER JOIN
                      dbo.Optional_Extra_GL ON glchart_OptionalExtra.account_code = dbo.Optional_Extra_GL.GL_Revenue_Account AND 
                      dbo.Optional_Extra_GL.Vehicle_Type_ID = 'Car' ON 
                      dbo.Contract_Charge_Item.Optional_Extra_ID = dbo.Optional_Extra_GL.Optional_Extra_ID LEFT OUTER JOIN
                      dbo.glchart_base glchart_Charge INNER JOIN
                      dbo.Charge_GL ON glchart_Charge.account_code = dbo.Charge_GL.GL_Revenue_Account AND dbo.Charge_GL.Vehicle_Type_ID = 'Car' ON 
                      dbo.Contract_Charge_Item.Charge_Type = dbo.Charge_GL.Charge_Type_ID
WHERE     (dbo.Contract_Charge_Item.Contract_Number = 937751)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[14] 2[18] 3) )"
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
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 0
               Left = 241
               Bottom = 244
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "glchart_OptionalExtra"
            Begin Extent = 
               Top = 13
               Left = 965
               Bottom = 121
               Right = 1141
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Optional_Extra_GL"
            Begin Extent = 
               Top = 11
               Left = 641
               Bottom = 104
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "glchart_Charge"
            Begin Extent = 
               Top = 209
               Left = 820
               Bottom = 365
               Right = 996
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Charge_GL"
            Begin Extent = 
               Top = 225
               Left = 550
               Bottom = 340
               Right = 736
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
      Begin ColumnWidths = 5
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 3720
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpGetContractGLRevenue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     Output = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpGetContractGLRevenue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'tmpGetContractGLRevenue'
GO