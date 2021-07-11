USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_11_Rates_Analysis_Maestro_Res]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP_Con_11_Rates_Analysis_Maestro_Res]
AS
SELECT     ISNULL(dbo.Reservation.Foreign_Confirm_Number,convert(varchar(20), dbo.Reservation.Confirmation_Number) ) Foreign_Confirm_Number, dbo.Contract.Contract_Number, (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL 
                      THEN dbo.Contract.Vehicle_Class_Code ELSE dbo.Reservation.Vehicle_Class_Code END) AS Vehicle_Class_Code, 
                      dbo.Contract.Sub_Vehicle_Class_Code, (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL 
                      THEN dbo.Contract.Pick_Up_Location_ID ELSE dbo.Reservation.Pick_Up_Location_ID END) AS Pick_Up_Location_ID, 
                      (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL THEN dbo.Contract.Drop_Off_Location_ID ELSE dbo.Reservation.Drop_Off_Location_ID END)
                       AS Drop_Off_Location_ID, (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL 
                      THEN dbo.Contract.Pick_Up_On ELSE dbo.Reservation.Pick_Up_On END) AS Pick_Up_On, (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL 
                      THEN dbo.Contract.Drop_Off_On ELSE dbo.Reservation.Drop_Off_On END) AS Drop_Off_On, ResChgHist.ResMadeTime AS TransTime, 
                      ResCanceTime.ResCancelTime, dbo.Reservation.Status AS ResStatus, dbo.Contract.Status AS Contract_status, DATEDIFF(mi, 
                      (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL THEN dbo.Contract.Pick_Up_On ELSE dbo.Reservation.Pick_Up_On END), 
                      (CASE WHEN dbo.Contract.Contract_Number IS NOT NULL THEN dbo.Contract.Drop_Off_On ELSE dbo.Reservation.Drop_Off_On END)) 
                      / 1440.0 AS Contract_Rental_Days, dbo.Reservation.BCD_Number,
                       dbo.Reservation.BCD_Rate_Org_ID Res_Rate_Org_ID,
                      dbo.Contract.BCD_Rate_Organization_ID Con_Rate_Org_ID,
                      
                      
                       dbo.Quoted_Vehicle_Rate.Rate_Name, NULL AS Rate_Level, 
                      SUM(CASE WHEN dbo.Quoted_Time_Period_Rate.Time_Period = 'Day' AND 
                      dbo.Quoted_Time_Period_Rate.Time_Period_Start = 1 THEN dbo.Quoted_Time_Period_Rate.Amount ELSE 0 END) AS Daily_Rate, 
                      MAX(CASE WHEN (dbo.Quoted_Time_Period_Rate.Time_Period = 'Day' AND dbo.Quoted_Time_Period_Rate.Time_Period_Start != 1) 
                      THEN dbo.Quoted_Time_Period_Rate.Amount ELSE 0.0 END) AS Addnl_Daily_rate, 
                      SUM(CASE WHEN dbo.Quoted_Time_Period_Rate.Time_Period = 'Week' THEN dbo.Quoted_Time_Period_Rate.Amount ELSE 0 END) AS Weekly_Rate, 
                      SUM(CASE WHEN dbo.Quoted_Time_Period_Rate.Time_Period = 'Hour' THEN dbo.Quoted_Time_Period_Rate.Amount ELSE 0 END) AS Hourly_Rate, 
                      SUM(CASE WHEN dbo.Quoted_Time_Period_Rate.Time_Period = 'Month' THEN dbo.Quoted_Time_Period_Rate.Amount ELSE 0 END) AS Monthly_Rate, 
                      'Maestro Reservation' AS Rate_Type, dbo.Reservation.IATA_Number, dbo.Reservation.First_Name, dbo.Reservation.Last_Name,
                      dbo.Reservation.Res_Booking_City Book_Source, dbo.Reservation.CID,
                      dbo.Reservation.Coupon_Code,
                      dbo.Reservation.Coupon_Description,                      
                      dbo.Reservation.Flex_Discount,
                      dbo.Reservation.Flat_Discount,
                      dbo.Reservation.Discount_ID,
					   dbo.Reservation.Program_Number	--,
                      --cci.UpgradeCharge
                      
FROM         dbo.RP__Reservation_Make_Time ResChgHist 
	INNER JOIN   dbo.Reservation 
			ON ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number 
	LEFT OUTER JOIN dbo.RP__Reservation_Cancel_Time ResCanceTime 
			ON  dbo.Reservation.Confirmation_Number = ResCanceTime.Confirmation_Number 
	LEFT OUTER JOIN dbo.Quoted_Vehicle_Rate 
	INNER JOIN  dbo.Quoted_Time_Period_Rate 
			ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID 
			ON   dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
    LEFT OUTER JOIN dbo.Contract            
            ON  dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number
                      		
					
WHERE     (
--dbo.Reservation.source_code='Maestro' and 
dbo.Reservation.Rate_id is null and dbo.Reservation.Quoted_Rate_ID is not null)
GROUP BY dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Confirmation_Number,dbo.Contract.Contract_Number, ResChgHist.ResMadeTime, ResCanceTime.ResCancelTime, 
                      dbo.Reservation.Status, dbo.Contract.Status, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Contract.Pick_Up_On, 
                      dbo.Contract.Drop_Off_On,
                       --dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, 
                       dbo.Contract.Pick_Up_Location_ID, 
                      dbo.Reservation.Pick_Up_Location_ID, dbo.Contract.Drop_Off_Location_ID, dbo.Reservation.Drop_Off_Location_ID, dbo.Contract.Vehicle_Class_Code, 
                      dbo.Reservation.Vehicle_Class_Code, dbo.Contract.Sub_Vehicle_Class_Code, dbo.Reservation.BCD_Number,
                      dbo.Reservation.BCD_Rate_Org_ID, 
                      dbo.Contract.BCD_Rate_Organization_ID, 
                      dbo.Quoted_Vehicle_Rate.Rate_Name, 
                      dbo.Reservation.IATA_Number, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name,dbo.Reservation.Res_Booking_City, 
                      dbo.Reservation.CID,
                      dbo.Reservation.Coupon_Code,
                      dbo.Reservation.Coupon_Description, 
                      dbo.Reservation.Flex_Discount,
                      dbo.Reservation.Flat_Discount,
                      dbo.Reservation.Discount_ID,
					   dbo.Reservation.Program_Number	--,
                      --cci.UpgradeCharge
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ResChgHist"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 84
               Left = 38
               Bottom = 192
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "ResCanceTime"
            Begin Extent = 
               Top = 6
               Left = 276
               Bottom = 84
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Quoted_Vehicle_Rate"
            Begin Extent = 
               Top = 192
               Left = 38
               Bottom = 300
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Quoted_Time_Period_Rate"
            Begin Extent = 
               Top = 300
               Left = 38
               Bottom = 408
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract"
            Begin Extent = 
               Top = 408
               Left = 38
               Bottom = 516
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 516
               Left = 38
               Bottom = 624
               Ri' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_Maestro_Res'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ght = 293
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_Maestro_Res'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_Maestro_Res'
GO
