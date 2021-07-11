USE [GISData]
GO
/****** Object:  View [dbo].[PM_Service_Schedule_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PM_Service_Schedule_vw]
AS
SELECT Veh.Unit_Number, Veh.Current_Km, PM.Service_Code, PM.Type, PM.Enabled, PM.Mileage_Tracking, PM.Recurring_Mileage, PM.Advance_Notification_Mileage, 
               PM.Mileage_Overdue_Restrict, PM.Date_Tracking, PM.Recurring_Time, PM.Tracking_Time_Unit, PM.Advance_Notification_Days, PM.Date_Overdue_Restrict
FROM  (SELECT dbo.Vehicle.Unit_Number, ISNULL(dbo.Vehicle.Overrid_PM_Schedule_Id, dbo.Vehicle_Model_Year.PM_Schedule_Id) AS PM_Schedule_Id, 
                              dbo.Vehicle.Current_Km
             FROM   dbo.Vehicle_Model_Year INNER JOIN
		dbo.Vehicle ON dbo.Vehicle_Model_Year.Vehicle_Model_ID = dbo.Vehicle.Vehicle_Model_ID
			INNER JOIN (Select * from     	Lookup_Table where Category = 'BudgetBC Company') OC
				ON dbo.Vehicle.Owning_Company_ID = CONVERT(smallint,OC.Code)
		Where dbo.Vehicle.current_vehicle_Status<'g'  and dbo.Vehicle.deleted=0
       ) AS Veh INNER JOIN
               dbo.PM_Schedule_Service AS PM ON Veh.PM_Schedule_Id = PM.Schedule_ID

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
         Begin Table = "Veh"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 130
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PM"
            Begin Extent = 
               Top = 7
               Left = 285
               Bottom = 148
               Right = 549
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Service_Schedule_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Service_Schedule_vw'
GO
