USE [GISData]
GO
/****** Object:  View [dbo].[PM_Tracking_Mileage_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PM_Tracking_Mileage_vw]
AS
SELECT PMS.Unit_Number, 
PMS.Service_Code, 
PMS.Type, 
PLS.Service_Date AS Last_Service_Date, 
PLS.KM_Reading, 
PMS.Current_Km,
PLS.KM_Reading + PMS.Recurring_Mileage as NextServiceKM,
--PMS.Mileage_Tracking, 
PMS.Recurring_Mileage, 
PMS.Advance_Notification_Mileage, 
               (CASE 
					WHEN (PLS.KM_Reading + PMS.Recurring_Mileage) - PMS.Current_Km <= PMS.Advance_Notification_Mileage 
							AND (PLS.KM_Reading + PMS.Recurring_Mileage)  - PMS.Current_Km >= 0 
						THEN 0 
					WHEN (PLS.KM_Reading + PMS.Recurring_Mileage)  - PMS.Current_Km < 0 
						THEN - 1 
					WHEN (PLS.KM_Reading + PMS.Recurring_Mileage) - PMS.Current_Km > PMS.Advance_Notification_Mileage 
						THEN 1 
				END	) 
               AS Status, PMS.Mileage_Overdue_Restrict
FROM  dbo.PM_Service_Schedule_vw AS PMS INNER JOIN
               dbo.PM_Last_Service_vw AS PLS ON PMS.Unit_Number = PLS.Unit_Number AND PMS.Service_Code = PLS.Service_Code
WHERE (PMS.Mileage_Tracking = 1)

union


SELECT PMS.Unit_Number, 
PMS.Service_Code, 
PMS.Type, 
NULL AS Last_Service_Date, 
NULL KM_Reading, 
PMS.Current_Km,
PMS.Recurring_Mileage as NextServiceKM,
--PMS.Mileage_Tracking, 
PMS.Recurring_Mileage, 
PMS.Advance_Notification_Mileage, 
0  AS Status, 
PMS.Mileage_Overdue_Restrict
FROM  dbo.PM_Service_Schedule_vw AS PMS 
Left   JOIN
             dbo.PM_Last_Service_vw AS PLS ON PMS.Unit_Number = PLS.Unit_Number AND PMS.Service_Code = PLS.Service_Code
WHERE (PMS.Mileage_Tracking = 1)  and  PLS.Unit_Number is null


--SELECT PMS.Unit_Number, 
--PMS.Service_Code, 
--PMS.Type, 
--NULL AS Last_Service_Date, 
--NULL, 
--PMS.Current_Km,
--PMS.Recurring_Mileage as NextServiceKM,
----PMS.Mileage_Tracking, 
--PMS.Recurring_Mileage, 
--PMS.Advance_Notification_Mileage, 
--0  AS Status, 
--PMS.Mileage_Overdue_Restrict
--FROM  dbo.PM_Service_Schedule_vw AS PMS 
----INNER JOIN
----               dbo.PM_Last_Service_vw AS PLS ON PMS.Unit_Number = PLS.Unit_Number AND PMS.Service_Code = PLS.Service_Code
--WHERE (PMS.Mileage_Tracking = 1) 
--	And	PMS.Unit_Number not in (Select Unit_Number from PM_Service_History PSH )
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
         Begin Table = "PMS"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 305
               Right = 312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PLS"
            Begin Extent = 
               Top = 7
               Left = 360
               Bottom = 148
               Right = 584
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Tracking_Mileage_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Tracking_Mileage_vw'
GO
