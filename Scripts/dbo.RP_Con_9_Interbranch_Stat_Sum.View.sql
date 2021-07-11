USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_9_Interbranch_Stat_Sum]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP_Con_9_Interbranch_Stat_Sum]
AS
SELECT    year(dbo.RP_Con_9_Interbranch_Stat_Rev.rbr_date) as TransYear, month(dbo.RP_Con_9_Interbranch_Stat_Rev.rbr_date) as TransMonth, LocOutCompany.Name AS PU_Company, LocInCompany.Name AS DO_Company, 
                      VehOwnCompany.Name AS VehOwningCompany, count(*) CountOfMonth, sum(dbo.RP_Con_9_Interbranch_Stat_Rev.Rental_Length) as RentalDays, sum(dbo.RP_Con_9_Interbranch_Stat_Rev.TnM) as TnM, 
                      sum(dbo.RP_Con_9_Interbranch_Stat_Rev.Upgrade) Upgrade, sum(dbo.RP_Con_9_Interbranch_Stat_Rev.Drop_Charge) as 'Drop Charge', 
                      sum(dbo.RP_Con_9_Interbranch_Stat_Rev.All_Level_LDW) as LDW, sum(dbo.RP_Con_9_Interbranch_Stat_Rev.PAI) as PAI, sum(dbo.RP_Con_9_Interbranch_Stat_Rev.PEC) as PEC, 
                      sum(dbo.RP_Con_9_Interbranch_Stat_Rev.Additional_Driver_Charge) as Additiona_Driver
FROM         dbo.RP_Con_9_Interbranch_Stat_Rev INNER JOIN
                      dbo.Owning_Company LocOutCompany ON dbo.RP_Con_9_Interbranch_Stat_Rev.PULocOCID = LocOutCompany.Owning_Company_ID INNER JOIN
                      dbo.Owning_Company VehOwnCompany ON dbo.RP_Con_9_Interbranch_Stat_Rev.VehOCID = VehOwnCompany.Owning_Company_ID INNER JOIN
                      dbo.Owning_Company LocInCompany ON dbo.RP_Con_9_Interbranch_Stat_Rev.DOLocOCID = LocInCompany.Owning_Company_ID
where rbr_date between '2006-01-01' and '2006-12-31'
group by
year(dbo.RP_Con_9_Interbranch_Stat_Rev.rbr_date), month(dbo.RP_Con_9_Interbranch_Stat_Rev.rbr_date), LocOutCompany.Name , LocInCompany.Name, 
                      VehOwnCompany.Name
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[60] 4[1] 2[20] 3) )"
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
         Begin Table = "RP_Con_9_Interbranch_Stat_Rev"
            Begin Extent = 
               Top = 46
               Left = 320
               Bottom = 404
               Right = 524
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "LocOutCompany"
            Begin Extent = 
               Top = 59
               Left = 568
               Bottom = 167
               Right = 797
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VehOwnCompany"
            Begin Extent = 
               Top = 317
               Left = 903
               Bottom = 425
               Right = 1132
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocInCompany"
            Begin Extent = 
               Top = 185
               Left = 722
               Bottom = 293
               Right = 951
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_9_Interbranch_Stat_Sum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_9_Interbranch_Stat_Sum'
GO
