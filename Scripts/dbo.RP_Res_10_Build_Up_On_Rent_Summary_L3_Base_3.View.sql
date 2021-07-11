USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_3]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
VIEW NAME:  	 RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1
PURPOSE:    	 This view stores all the counts in columns for both local and foreign locations

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_3]
AS
SELECT     Date_Col.Rpt_Date, Loc_Col.Location_ID, Loc_Col.Location_Name, VT.Vehicle_Type_ID
FROM         (SELECT DISTINCT Rpt_Date
                       FROM          dbo.RP_Res_10_Build_Up_On_Rent_All_Date_L1_Base WITH (NOLOCK)) AS Date_Col CROSS JOIN
                          (SELECT DISTINCT Location_ID, Location_Name
                            FROM          dbo.RP_Res_10_Build_Up_On_Rent_Summary_L3_Main WITH (NOLOCK)) AS Loc_Col CROSS JOIN
                          (SELECT DISTINCT Vehicle_Type_ID
                            FROM          dbo.Vehicle_Class WITH (NOLOCK)) AS VT

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
         Begin Table = "Date_Col"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 69
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Loc_Col"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 84
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VT"
            Begin Extent = 
               Top = 6
               Left = 418
               Bottom = 69
               Right = 578
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_3'
GO
