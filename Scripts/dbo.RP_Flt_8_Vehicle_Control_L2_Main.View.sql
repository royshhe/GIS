USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_8_Vehicle_Control_L2_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
VIEW NAME: RP_Flt_8_Vehicle_Control_L2_Main
PURPOSE: Get the required information for Vehicle Control Main Report

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/08
USED BY: RP_SP_Flt_8_Vehicle_Control_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/03/29	Compare the Check Out and Movement Out times on the latest VOC and VM 
				records respectively and report the km and location information from 
				the record with the latest time. If the CO and MO times are the same,
				select the larger KM from these 2 records. 
Joseph Tseung 	2000/03/31	Include the case where there is only one of vehicle on contract/vehicle
				movement records for selecting the km and location.
Joseph Tseung	2000/04/05	If the Actual Check In Date/Time is not null for the last contract of the 
				vehicle, don't show the contract number and expected check in date/time
*/
CREATE VIEW [dbo].[RP_Flt_8_Vehicle_Control_L2_Main]
AS
SELECT     dbo.Vehicle.Unit_Number, dbo.Vehicle.Current_Licence_Plate, dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, 
                      dbo.Vehicle_Class.Vehicle_Type_ID, dbo.Vehicle.Vehicle_Class_Code, dbo.Vehicle_Class.Vehicle_Class_Name, 
                      dbo.Lookup_Table.Value AS Vehicle_Rental_Status, Lookup_Table1.Value AS Vehicle_Condition_Status,
						 
                      (Case When Lookup_Table3.Value='Pulled For Disposal'  Then
						(Case When dbo.Vehicle.Program=1 Then 'Pulled For TurnBack'
							 Else 'Pulled For Sale'
						End)						
                      Else 
						Lookup_Table3.Value 
                      End) AS Vehicle_Status, 
                       
                      CASE WHEN Vehicle.Current_Rental_Status = 'b' AND vVoc.Actual_Check_IN IS NULL THEN Convert(Varchar,vVoc.Contract_Number)+vVoc.ITB_Indicator  ELSE NULL 
                      END AS Contract_Number, 
                      CASE WHEN vVoc.Checked_Out > vVM.Movement_Out THEN vVoc.Km WHEN vVoc.Checked_Out < vVM.Movement_Out THEN vVm.Km WHEN vVoc.Checked_Out
                       IS NOT NULL AND vVM.Movement_Out IS NULL THEN vVoc.Km WHEN vVoc.Checked_Out IS NULL AND vVM.Movement_Out IS NOT NULL 
                      THEN vVm.Km WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NOT NULL AND vVoc.Checked_Out = vVM.Movement_Out AND 
                      ISNULL(vVoc.Km, 0) >= ISNULL(vVm.Km, 0) THEN vVoc.Km WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NOT NULL AND 
                      vVoc.Checked_Out = vVM.Movement_Out AND ISNULL(vVoc.Km, 0) < ISNULL(vVm.Km, 0) THEN vVm.Km ELSE Vehicle.Current_Km END AS Km_Number,
                       CASE WHEN Vehicle.Current_Rental_Status = 'b' AND vVoc.Actual_Check_IN IS NULL THEN vVoc.Expected_Check_In ELSE NULL 
                      END AS Expected_Check_In, 
                      CASE WHEN vVoc.Checked_Out > vVM.Movement_Out THEN vVoc.Location_ID WHEN vVoc.Checked_Out < vVM.Movement_Out THEN vVm.Location_ID WHEN
                       vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NULL THEN vVoc.Location_ID WHEN vVoc.Checked_Out IS NULL AND 
                      vVM.Movement_Out IS NOT NULL THEN vVm.Location_ID WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NOT NULL AND 
                      vVoc.Checked_Out = vVM.Movement_Out AND ISNULL(vVoc.Km, 0) >= ISNULL(vVm.Km, 0) 
                      THEN vVoc.Location_ID WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NOT NULL AND 
                      vVoc.Checked_Out = vVM.Movement_Out AND ISNULL(vVoc.Km, 0) < ISNULL(vVm.Km, 0) 
                      THEN vVm.Location_ID ELSE Vehicle.Current_Location_ID END AS Vehicle_Location_ID, dbo.Vehicle.Do_Not_Rent_Past_Km, 
                      dbo.Vehicle.Do_Not_Rent_Past_Days, dbo.Vehicle.Ownership_Date, CASE WHEN (vVoc.Vehicle_Not_Present_Location IS NOT NULL AND 
                      Vehicle.Current_Location_ID IN
                          (SELECT     code
                            FROM          Lookup_Table
                            WHERE      Category = 'Virtual Location')) THEN vVoc.Vehicle_Not_Present_Location WHEN (vVoc.Vehicle_Not_Present_Location IS NOT NULL AND 
                      Vehicle.Current_Rental_Status IN ('a', 'b') AND NOT EXISTS
                          (SELECT     *
                            FROM          Vehicle_Movement vm
                            WHERE      vm.Unit_Number = Vehicle.Unit_Number AND vm.Movement_Out > vVoc.Checked_Out)) 
                      THEN vVoc.Vehicle_Not_Present_Location ELSE NULL END AS Vehicle_Not_Present_Location, dbo.Vehicle.MVA_Number,
                      vVoc.Pick_Up_On,
                      vVoc.Renter_Name,
                      dbo.vehicle.Next_Scheduled_Maintenance
FROM         dbo.Vehicle WITH (NOLOCK) INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID LEFT OUTER JOIN
                      dbo.Lookup_Table ON dbo.Vehicle.Current_Rental_Status = dbo.Lookup_Table.Code AND 
                      dbo.Lookup_Table.Category = 'Vehicle Rental Status' LEFT OUTER JOIN
                      dbo.Lookup_Table AS Lookup_Table1 ON dbo.Vehicle.Current_Condition_Status = Lookup_Table1.Code AND 
                      Lookup_Table1.Category = 'Vehicle Condition Status' INNER JOIN
                      dbo.Lookup_Table AS Lookup_Table2 ON dbo.Vehicle.Owning_Company_ID = Lookup_Table2.Code AND 
                      Lookup_Table2.Category = 'BudgetBC Company' INNER JOIN
                      dbo.Lookup_Table AS Lookup_Table3 ON dbo.Vehicle.Current_Vehicle_Status = Lookup_Table3.Code AND 
                      Lookup_Table3.Category = 'Vehicle Status' LEFT OUTER JOIN
                      dbo.RP_Flt_8_Vehicle_Control_L1_Base_VOC AS vVoc ON dbo.Vehicle.Unit_Number = vVoc.Unit_Number AND 
                      dbo.Vehicle.Current_Rental_Status IN ('a', 'b') LEFT OUTER JOIN
                      dbo.RP_Flt_8_Vehicle_Control_L1_Base_VM AS vVm ON dbo.Vehicle.Unit_Number = vVm.Unit_Number
WHERE     (dbo.Vehicle.Current_Vehicle_Status = 'a' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'b' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'c' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'd' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'e' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'f' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'g' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'j' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'k' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'l') AND (dbo.Vehicle.Deleted = 0)
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
         Begin Table = "Vehicle"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 40
         End
         Begin Table = "Vehicle_Class"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Vehicle_Model_Year"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lookup_Table"
            Begin Extent = 
               Top = 6
               Left = 307
               Bottom = 114
               Right = 458
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lookup_Table1"
            Begin Extent = 
               Top = 114
               Left = 306
               Bottom = 222
               Right = 457
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lookup_Table2"
            Begin Extent = 
               Top = 222
               Left = 254
               Bottom = 330
               Right = 405
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lookup_Table3"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 189
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Flt_8_Vehicle_Control_L2_Main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vVoc"
            Begin Extent = 
               Top = 330
               Left = 227
               Bottom = 438
               Right = 452
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vVm"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 192
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Flt_8_Vehicle_Control_L2_Main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Flt_8_Vehicle_Control_L2_Main'
GO
