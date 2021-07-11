USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_Goverment_Tracking_sum_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*----------------------------------------------------------------------------------------------------------------------
	Programmer:	Roy He
	Date:		06 Aug2005
	Details		Time, Km charges and LDW total for each contract
	Modification:		Name:		Date:		Detail:

----------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[Contract_Revenue_Goverment_Tracking_sum_vw]
AS
SELECT     RBR_Date, Contract_Number, Confirmation_Number, First_Name, Last_Name, PU_Location,LocationName, DO_Location, Owning_Company_ID, Company_Name, 
                      Organization_Name, PULoc_OID, DOLoc_OID, Vehicle_Type_ID, REPLACE(Vehicle_Class_Name, '''', '') AS Vehicle_Class_Name, Model_Name, 
                      Model_Year, Pick_Up_On, Contract_Rental_Days, KmDriven, Walk_Up, Rate_Name, Rate_Purpose_ID, Org_Type, BCD_number, 
                      SUM(CASE WHEN Charge_Type IN (10, 50, 51, 52) THEN Amount ELSE 0 END) AS TimeCharge, SUM(CASE WHEN Charge_Type IN (20) 
                      THEN Amount ELSE 0 END) AS Upgrade, SUM(CASE WHEN Charge_Type IN (11) THEN Amount ELSE 0 END) AS KMCharge, 
                      SUM(CASE WHEN Charge_Type IN (33) THEN (Amount) ELSE 0 END) AS DropOff_Charge, 
                      SUM(CASE WHEN Charge_Type = 14 THEN Amount ELSE 0 END) AS FPO, SUM(CASE WHEN Charge_Type = 34 THEN Amount ELSE 0 END) 
                      AS Additional_Driver_Charge, SUM(CASE WHEN Optional_Extra_ID IN (1, 2, 3) THEN Amount ELSE 0 END) AS All_Seats, 
                      SUM(CASE WHEN Optional_Extra_ID IN (23, 25) THEN Amount ELSE 0 END) AS Driver_Under_Age, SUM(CASE WHEN Optional_Extra_ID IN (8, 9, 10, 
                      11, 12, 13, 14, 15, 16, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 43, 44) OR
                      (Charge_Type = 61 AND Charge_Item_Type = 'a') THEN Amount ELSE 0 END) AS All_Level_LDW, SUM(CASE WHEN Optional_Extra_ID = 20 OR
                      (Charge_Type = 62 AND Charge_Item_Type = 'a') THEN Amount ELSE 0 END) AS PAI, SUM(CASE WHEN Optional_Extra_ID = 21 OR
                      (Charge_Type = 63 AND Charge_Item_Type = 'a') THEN Amount ELSE 0 END) AS PEC, SUM(CASE WHEN Optional_Extra_ID IN (4, 26) 
                      THEN Amount ELSE 0 END) AS Ski_Rack, SUM(CASE WHEN Optional_Extra_id IN (5, 6, 35) THEN Amount ELSE 0 END) AS All_Dolly, 
                      SUM(CASE WHEN Optional_Extra_id IN (17, 18) THEN Amount ELSE 0 END) AS All_Gates, 
                      SUM(CASE WHEN Optional_Extra_id = 7 THEN Amount ELSE 0 END) AS Blanket
FROM         dbo.Contract_Revenue_Goverment_Tracking_Detail_vw
WHERE     (BCD_number IS NULL) OR
                      (BCD_number NOT IN 
                      ('A044300', 
                      'A159600', 
                      'A162100', 
                      'Z464400', 
                      'Y069300', 
                      'T788300', 
                      'A136100', 
                      'A529200', 
                      'A411700', 
                      'A376100', 
                      'Y492100',
                      'A044330',   
					  'A044390'   

                      ))
GROUP BY RBR_Date, Contract_Number, Confirmation_Number, Last_Name, First_Name, PU_Location,LocationName, DO_Location, Vehicle_Type_ID, Vehicle_Class_Name, 
                      Model_Name, Model_Year, Contract_Rental_Days, Walk_Up, Rate_Name, Rate_Purpose_ID, Org_Type, BCD_number, Owning_Company_ID, 
                      Company_Name, Organization_Name, PULoc_OID, DOLoc_OID, Pick_Up_On, KmDriven


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
         Begin Table = "Contract_Revenue_Goverment_Tracking_Detail_vw"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 243
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Revenue_Goverment_Tracking_sum_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Revenue_Goverment_Tracking_sum_vw'
GO
