USE [GISData]
GO
/****** Object:  View [dbo].[armaster]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[armaster]
AS
SELECT customer_code, ship_to_code, address_name, address_type, status_type, price_code, credit_limit, (CASE WHEN Rtrim(addr1) <> '' AND addr1 IS NOT NULL 
               THEN Rtrim(addr1) + ' ' ELSE '' END) + (CASE WHEN Rtrim(addr2) <> '' AND addr2 IS NOT NULL THEN Rtrim(addr2) + ' ' ELSE '' END) + (CASE WHEN Rtrim(addr3) 
               <> '' AND addr3 IS NOT NULL THEN Rtrim(addr3) + ' ' ELSE '' END) + (CASE WHEN Rtrim(addr4) <> '' AND addr4 IS NOT NULL THEN Rtrim(addr4) + ' ' ELSE '' END) 
               + (CASE WHEN Rtrim(addr5) <> '' AND addr5 IS NOT NULL THEN Rtrim(addr5) + ' ' ELSE '' END) + (CASE WHEN Rtrim(addr6) <> '' AND addr6 IS NOT NULL 
               THEN Rtrim(addr6) + ' ' ELSE '' END) AS Address, attention_name, attention_phone, resale_num, city, state, postal_code, country, url AS Comment, 
               tlx_twx AS FaxNo, po_num_reqd_flag, claim_num_reqd_flag
FROM  dbo.armaster_base
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "armaster_base"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 299
               Right = 283
            End
            DisplayFlags = 280
            TopColumn = 78
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'armaster'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'armaster'
GO
