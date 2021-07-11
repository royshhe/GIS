USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
VIEW NAME:  	 RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2
PURPOSE:    	 This view groups the foreign locations in one column called "Z Foreign Locations"

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	Stored Procedure RP_SP_Res_10_Build_Up_On_Rent
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Main]
AS
SELECT     vLocal.Rpt_Date, vLocal.Location_ID, dbo.Location.Location AS Location_Name, dbo.Vehicle_Class.Vehicle_Type_ID, vLocal.Vehicle_Class_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Class.DisplayOrder, 
                      dbo.Vehicle_Class.Vehicle_Class_Code + '-' + dbo.Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name, vLocal.Cdt_Cnt, 
                      vLocal.Cor1_Cnt, vLocal.Cor2_Cnt, vLocal.Cor3_Cnt, vLocal.Od_Cnt, vLocal.Rdt1_Cnt, vLocal.Rdt2_Cnt, vLocal.Rpu1_Cnt, vLocal.Rpu2_Cnt
FROM         dbo.RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2 AS vLocal INNER JOIN
                      dbo.Location ON vLocal.Location_ID = dbo.Location.Location_ID AND dbo.Location.Rental_Location = 1 INNER JOIN
                      dbo.Vehicle_Class ON vLocal.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Lookup_Table ON dbo.Lookup_Table.Code = dbo.Location.Owning_Company_ID AND dbo.Lookup_Table.Category = 'BudgetBC Company'
UNION ALL
SELECT     vForeign.Rpt_Date, 999 AS Location_ID, 'Z Foreign Locations' AS Location_Name, Vehicle_Class_1.Vehicle_Type_ID, vForeign.Vehicle_Class_Code, 
                      Vehicle_Class_1.Vehicle_Class_Name, Vehicle_Class_1.DisplayOrder, 
                      Vehicle_Class_1.Vehicle_Class_Code + '-' + Vehicle_Class_1.Vehicle_Class_Name AS Vehicle_Class_Code_Name, vForeign.Cdt_Cnt, 
                      vForeign.Cor1_Cnt, vForeign.Cor2_Cnt, vForeign.Cor3_Cnt, vForeign.Od_Cnt, vForeign.Rdt1_Cnt, vForeign.Rdt2_Cnt, vForeign.Rpu1_Cnt, 
                      vForeign.Rpu2_Cnt
FROM         dbo.RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2 AS vForeign WITH (NOLOCK) INNER JOIN
                      dbo.Location AS Location_1 ON vForeign.Location_ID = Location_1.Location_ID AND Location_1.Rental_Location = 1 INNER JOIN
                      dbo.Vehicle_Class AS Vehicle_Class_1 ON vForeign.Vehicle_Class_Code = Vehicle_Class_1.Vehicle_Class_Code INNER JOIN
                      dbo.Lookup_Table AS Lookup_Table_1 ON Lookup_Table_1.Code <> Location_1.Owning_Company_ID AND 
                      Lookup_Table_1.Category = 'BudgetBC Company'
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
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
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
      Begin ColumnWidths = 5
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Res_10_Build_Up_On_Rent_Summary_L3_Main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Res_10_Build_Up_On_Rent_Summary_L3_Main'
GO
