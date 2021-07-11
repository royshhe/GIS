USE [GISData]
GO
/****** Object:  View [dbo].[RP_FLT_14_Vehicle_Revenue_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*----------------------------------------------------------------------------------------------------------------------
	Developed By:	Roy he
	Date:		15 Jan 2002
	Details		Get all data for Vehicle Revenue
	Modification:		Name:		Date:		Detail:

---------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[RP_FLT_14_Vehicle_Revenue_Main]
AS
SELECT		RBR_Date,
			Contract_Number, 
			unit_number, 
			Vehicle_Type_ID, 
			--(Case When Vehicle_Class_Code in ('1', '3', '4', 'c', 'l') then '1'
			--     When Vehicle_Class_Code in ('-', 'd', 'e') then 'e'
			--     When Vehicle_Class_Code in ('0', 'v') then 'v'
			--     When Vehicle_Class_Code in ('+', '=') then '+'
			--     Else  Vehicle_Class_Code
			--End)  Vehicle_Class_Code,
			Vehicle_Class_Code,
			Vehicle_Class_Name,
			DisplayOrder, 
			model_name, 
			model_year, 
			hub_id, 
			Hub_Name, 
			Location_id, 
            Location_Name, 
			--DaysInService,

				-- Not only consider walkup here --- roy he

			SUM(CASE WHEN charge_type = 'Upgrade Charge' 
						THEN amount 
						ELSE 0 END) AS Upgrade, 
			SUM(CASE WHEN Charge_Type IN ('Time Charge','Flex Discount', 'Member Discount', 'Contract Discount', 'Upgrade Charge') 
						THEN Amount 
						ELSE 0 END) AS TimeCharge, 
            SUM(CASE WHEN charge_type = 'KM Charge' 
						THEN amount 
						ELSE 0 END) AS KMs, 
			SUM(CASE WHEN OptionalExtraType IN ('LDW') OR (Charge_Type = 'LDW' AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS LDW, 
			SUM(CASE WHEN OptionalExtraType IN ('PAI','PAE','PEC', 'CARGO') OR (Charge_Type  IN ('PAI','PAE','PEC/Cargo') AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS PAI, 
			SUM(CASE WHEN OptionalExtraType IN ('RSN') OR (Charge_Type IN ('RSN') AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS PEC, 
			SUM(CASE WHEN Optional_Extra IN ('Ski Rack','Snow Board Rack') OR
							Optional_Extra LIKE '%Dolly%' OR
							Optional_Extra LIKE '%Gate%' OR
							Optional_Extra = ' %Blanket%' 
						THEN Amount 
						ELSE 0 END) AS MovingAids, 
			SUM(CASE WHEN Optional_Extra IN ('Child Seat', 'Booster Seat', 'Infant Seat') 
						THEN Amount 
						ELSE 0 END) AS BabySeats, 
			SUM(CASE WHEN charge_type IN ('Sales Accessory','Truck Accessory') 
						THEN amount 
						ELSE 0 END) AS MovingSupply, 
			SUM(CASE WHEN Charge_Type IN ('Location Fee') 
						THEN Amount 
						ELSE 0 END) AS LRF, 
            SUM(CASE WHEN Charge_Type IN ('VLF/AC Recovery Fee','VLF/AC Tax Recovery') 
						THEN Amount 
						ELSE 0 END) AS VLF, 
			SUM(CASE WHEN Charge_Type IN ('Drop Charge') 
						THEN Amount 
						ELSE 0 END) AS DropCharge, 
			SUM(CASE WHEN Charge_Type IN ('Additional Driver', 'Additional Driver Charge') 
						THEN Amount 
						ELSE 0 END) AS Additional_Driver_Charge, 
			SUM(CASE WHEN Optional_Extra LIKE 'Driver Age%' OR Charge_Type IN ('Under Age Surcharge') 
						THEN Amount 
						ELSE 0 END) AS Driver_Under_Age, 
			SUM(CASE WHEN OptionalExtraType IN ('BUYDOWN') 
						THEN Amount 
						ELSE 0 END) AS BuyDown, 
			SUM(CASE WHEN OptionalExtraType IN ('GPS') 
						THEN Amount 
						ELSE 0 END) AS GPS, 
            SUM(CASE WHEN Charge_Type IN ('FPO','GSO',' Fuel Charge') 
						THEN Amount 
						ELSE 0 END) AS FPO, 
			SUM(CASE WHEN  OptionalExtraType IN ('ELI')  or 
							 Charge_Type IN ('ELI') 
						THEN Amount 
						ELSE 0 END) AS ELI, 
			SUM(CASE WHEN Charge_Type IN ('Energy Recovery Fee') 
						THEN Amount 
						ELSE 0 END) AS ERF, 
			SUM(CASE WHEN Optional_Extra LIKE '%Winter Tire%' 
						THEN Amount ELSE 0 END) AS SnowTires, 
            SUM(CASE WHEN Charge_Type LIKE 'out of %' or  OptionalExtraType IN ('OA')  
						THEN Amount 
						ELSE 0 END) AS CrossBoardSurcharge
FROM         dbo.RP_FLT_14_Vehicle_Revenue_L1
GROUP BY RBR_Date, unit_number, Contract_Number, Vehicle_Type_ID, Vehicle_Class_Code, Vehicle_Class_Name,DisplayOrder, model_name, model_year, hub_id, Hub_Name, 
                      Location_id, Location_Name
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[7] 2[34] 3) )"
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
         Begin Table = "RP_FLT_14_Vehicle_Revenue_L1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 250
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_FLT_14_Vehicle_Revenue_Main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_FLT_14_Vehicle_Revenue_Main'
GO
