USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Charge_Sum_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*------------------------------------------------------------------------------------------------------------------
	Programmer:	Roy He
	Date:		27 Feb 2002
	Details		Sum all items, seperate in different columns (Summary)
	Modification:		Name:		Date:		Detail:

-------------------------------------------------------------------------------------------------------------------

*/
CREATE VIEW [dbo].[Contract_Charge_Sum_vw]
AS
SELECT      
		Contract_Number,
		SUM(CASE WHEN charge_type = 20 THEN amount ELSE 0 END) AS Upgrade,
		--SUM(CASE WHEN charge_type = 20 THEN Quantity ELSE 0 END) AS UpgradeQuantity,
		SUM(CASE WHEN charge_type = 33 THEN amount ELSE 0 END) AS DropOffCharge,
		SUM(CASE WHEN Charge_Type IN (10, 11,  50, 51, 52)   THEN Amount ELSE 0 END) AS TnK,
		SUM(CASE WHEN Charge_Type = 14 THEN Amount ELSE 0 END) AS FPO, 
		SUM(CASE WHEN Charge_Type = 18 THEN Amount ELSE 0 END) AS  Fuel, 
		SUM(CASE WHEN Charge_Type = 34 THEN Amount ELSE 0 END) AS Additional_Driver_Charge,

		SUM(CASE WHEN Charge_Type in (30,35) THEN Amount ELSE 0 END) AS Location_Fee,
		SUM(CASE WHEN Charge_Type in (96,97) THEN Amount ELSE 0 END) AS Licence_Fee,
		SUM(CASE WHEN Charge_Type = 39 THEN Amount ELSE 0 END) AS CFC,


		SUM(CASE WHEN Optional_Extra_ID IN (1, 2, 3)   THEN Amount ELSE 0 END) AS All_Seats, 
		SUM(CASE WHEN Optional_Extra_ID IN (23, 25) THEN Amount ELSE 0 END) AS Driver_Under_Age, 
		--SUM(CASE WHEN OptionalExtraType IN ('LDW', 'BUYDOWN') OR (Charge_Type = 61 AND Charge_Item_Type = 'a')  or Charge_Type in (93) THEN Amount ELSE 0 END) AS All_Level_LDW, 			 
		SUM(Case When OptionalExtraType IN ('LDW', 'BUYDOWN') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 61 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
			--OR (Charge_Type = 64 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
			Then Amount
			ELSE 0
			END)						as All_Level_LDW,
			
		SUM(Case When OptionalExtraType IN ('PAI','PAE','PEC') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type in ( 62,63) AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PAI
			Then Amount
			ELSE 0
			END)						as PAI,
		SUM(Case When OptionalExtraType IN ('RSN') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 83  AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as PEC,

		SUM(Case When OptionalExtraType IN ('RSN') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 83  AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as RSN,

		SUM(Case When OptionalExtraType IN ('ELI') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 67 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as ELI,
		
			
		SUM(Case	When Optional_Extra_ID in (88,89,90,206,225) 
						OR (Charge_Type = 89)
			Then Amount
			ELSE 0
			END)						as Snow_Tire,	
			
		SUM(CASE WHEN Optional_Extra_ID IN (4, 26)  THEN Amount ELSE 0 END) AS Ski_Rack, 
		SUM(CASE WHEN Optional_Extra_id IN (5, 6, 35) THEN Amount ELSE 0 END) AS All_Dolly, 
		SUM(Case	When OptionalExtraType in ('OA') 
		OR (Charge_Type = 47  AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as Our_Of_Area,
		SUM(CASE WHEN Optional_Extra_id IN (17, 18) THEN Amount ELSE 0 END) AS All_Gates, 
		SUM(CASE WHEN Optional_Extra_id = 7 THEN Amount ELSE 0 END) AS Blanket,
		SUM(CASE WHEN OptionalExtraType IN ('GPS') THEN Amount ELSE 0 END) AS GPS,
		SUM(CASE WHEN Charge_Type IN (15,16,17,19,21,22,24,25,26,27,28,29,31,32,38,39,40,60,65,66,70,94,95)   THEN Amount ELSE 0 END) AS Misc,

		SUM(GST_Amount)+SUM(GST_Amount_Included) GST,
		SUM(PST_Amount)+SUM(PST_Amount_Included) PST, 
		SUM(PVRT_Amount)+SUM(PVRT_Amount_Included) PVRT
FROM         dbo.Contract_Charge_vw WITH (NOLOCK)
GROUP BY Contract_Number


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[19] 2[36] 3) )"
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
         Begin Table = "Contract_Charge_vw"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 169
               Right = 249
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
      Begin ColumnWidths = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Charge_Sum_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Charge_Sum_vw'
GO
