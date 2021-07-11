USE [GISData]
GO
/****** Object:  View [dbo].[Pticket]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Pticket]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, dbo.Contract.Address_1, dbo.Contract.Address_2, dbo.Contract.City, 
                      dbo.Contract.Province_State, dbo.Contract.Postal_Code, dbo.Contract.Country, dbo.Contract_Charge_Item.Charge_Type, 
                      dbo.Contract_Charge_Item.Charge_description, dbo.Contract_Charge_Item.Amount, dbo.Contract_Charge_Item.GST_Amount, 
                      dbo.Contract_Charge_Item.PST_Amount, dbo.Contract_Charge_Item.PVRT_Amount, dbo.Contract_Charge_Item.Ticket_Number, 
                      dbo.Contract_Charge_Item.Issuer, dbo.Contract_Charge_Item.Issuing_Date, dbo.Business_Transaction.RBR_Date, 
                      dbo.Business_Transaction.Business_Transaction_ID
FROM         dbo.Contract INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID
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
         Begin Table = "Contract"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 306
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 30
         End
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 24
               Left = 601
               Bottom = 262
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 21
         End
         Begin Table = "Business_Transaction"
            Begin Extent = 
               Top = 61
               Left = 962
               Bottom = 169
               Right = 1162
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Pticket'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Pticket'
GO
