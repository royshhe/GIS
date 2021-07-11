USE [GISData]
GO
/****** Object:  View [dbo].[Tax_Auditing_Contract_Detail]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Tax_Auditing_Contract_Detail]
AS
SELECT     dbo.Contract_Charge_Item.Contract_Number, dbo.Contract.Pick_Up_On, dbo.Business_Transaction.RBR_Date, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, dbo.Contract.First_Name, 
                      dbo.Contract.Last_Name, dbo.Contract_Charge_Item.Charge_description, dbo.Contract_Charge_Item.Quantity, ChargeType.[value] AS Charge_Type, 
                      dbo.Optional_Extra.Optional_Extra, dbo.Contract_Charge_Item.Unit_Amount, dbo.Contract_Charge_Item.Unit_Type, dbo.Contract_Charge_Item.Amount, 
                      dbo.Contract_Charge_Item.GST_Amount, dbo.Contract_Charge_Item.PST_Amount, dbo.Contract_Charge_Item.PVRT_Amount, 
                      dbo.Contract_Charge_Item.GST_Included, dbo.Contract_Charge_Item.PST_Included, dbo.Contract_Charge_Item.PVRT_Included, 
                      dbo.Contract_Charge_Item.GST_Exempt, dbo.Contract_Charge_Item.PST_Exempt, dbo.Contract_Charge_Item.PVRT_Exempt, 
                      dbo.Contract.GST_Exempt_Num, dbo.Contract.PST_Exempt_Num, dbo.Contract_Charge_Item.PVRT_Days
FROM         dbo.Contract_Charge_Item INNER JOIN
                      dbo.Business_Transaction ON 
                      dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID INNER JOIN
                      dbo.Contract ON dbo.Contract_Charge_Item.Contract_Number = dbo.Contract.Contract_Number INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON 
                      dbo.Contract_Charge_Item.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Vehicle_Class ON dbo.Contract.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Vehicle ON dbo.RP__Last_Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID LEFT OUTER JOIN
                      dbo.Optional_Extra ON dbo.Contract_Charge_Item.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID AND 
                      dbo.Optional_Extra.Delete_Flag = 0 LEFT OUTER JOIN
                          (SELECT DISTINCT code, value
                            FROM          dbo.Lookup_Table
                            WHERE      Category LIKE '%charge type%') ChargeType ON dbo.Contract_Charge_Item.Charge_Type = ChargeType.code
WHERE     (dbo.Business_Transaction.RBR_Date BETWEEN '2007-03-05' AND '2007-03-15')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[48] 4[11] 2[23] 3) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 289
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Business_Transaction"
            Begin Extent = 
               Top = 346
               Left = 61
               Bottom = 531
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract"
            Begin Extent = 
               Top = 103
               Left = 880
               Bottom = 386
               Right = 1096
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ChargeType"
            Begin Extent = 
               Top = 6
               Left = 303
               Bottom = 91
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Optional_Extra"
            Begin Extent = 
               Top = 0
               Left = 782
               Bottom = 115
               Right = 955
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 0
               Left = 1285
               Bottom = 115
               Right = 1525
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 134
               Left = 376
               Bottom = 249
           ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Tax_Auditing_Contract_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Right = 607
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle"
            Begin Extent = 
               Top = 61
               Left = 1566
               Bottom = 302
               Right = 1798
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Model_Year"
            Begin Extent = 
               Top = 146
               Left = 1304
               Bottom = 283
               Right = 1483
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
      Begin ColumnWidths = 28
         Width = 284
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
         Width = 2385
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Tax_Auditing_Contract_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Tax_Auditing_Contract_Detail'
GO
