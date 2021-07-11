USE [GISData]
GO
/****** Object:  View [dbo].[AM_Detail_Record_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AM_Detail_Record_vw]
AS
SELECT     (SELECT     dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AirMilesEFT') AND (dbo.SystemSettingValues.ValueName = 'StoreNumber')) AS Store_Number, 
                      dbo.Contract.FF_Member_Number, '00' AS AMTM_Tran_Type, dbo.Contract.Contract_Number AS Invoice_Number, 'S' AS Entry_Mode, 
                      CONVERT(varchar(2), DATEPART(hh, dbo.AM_Contract_TnM.Transaction_Date)) + CONVERT(varchar(2), DATEPART(mi, 
                      dbo.AM_Contract_TnM.Transaction_Date)) AS Transaction_Time, CONVERT(varchar(2), DAY(dbo.AM_Contract_TnM.Transaction_Date)) 
                      + CONVERT(varchar(2), MONTH(dbo.AM_Contract_TnM.Transaction_Date)) + SUBSTRING(CONVERT(varchar(4), 
                      YEAR(dbo.AM_Contract_TnM.Transaction_Date)), 3, 2) AS Transaction_Date,
                          (SELECT     dbo.SystemSettingValues.SettingValue
                            FROM          dbo.SystemSetting INNER JOIN
                                                   dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                            WHERE      (dbo.SystemSetting.SettingName = 'AirMilesEFT') AND (dbo.SystemSettingValues.ValueName = 'SponsorNumber')) AS Sponsor_Number, 
                      '01' AS Base_Offer_Code, dbo.AM_Contract_TnM.TnM_Amount AS Amount, CONVERT(INT, dbo.AM_Contract_TnM.TnM_Amount / 10) AS Mile_Points, 
                      3 AS Multiply_Factor, CONVERT(INT, dbo.AM_Contract_TnM.TnM_Amount / 10) * 2 AS Multipler_Miles, '9999' AS BONUS_OFFER_CODE, 
                      1 AS Offer_Quantity, 0 AS Bonus_Miles, 2 AS Offer_Type
FROM         dbo.Contract INNER JOIN
                      dbo.Frequent_Flyer_Plan ON dbo.Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID INNER JOIN
                      dbo.Air_Miles_Card ON dbo.Contract.FF_Member_Number = dbo.Air_Miles_Card.CARD_number INNER JOIN
                      dbo.AM_Contract_TnM ON dbo.Contract.Contract_Number = dbo.AM_Contract_TnM.Contract_Number
WHERE     (dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Air Miles') AND (dbo.AM_Contract_TnM.RBR_Date = '2006-12-13')
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
               Bottom = 114
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Frequent_Flyer_Plan"
            Begin Extent = 
               Top = 244
               Left = 3
               Bottom = 352
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Air_Miles_Card"
            Begin Extent = 
               Top = 216
               Left = 384
               Bottom = 324
               Right = 553
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AM_Contract_TnM"
            Begin Extent = 
               Top = 6
               Left = 733
               Bottom = 114
               Right = 898
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AM_Detail_Record_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AM_Detail_Record_vw'
GO
