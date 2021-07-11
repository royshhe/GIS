USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_11_Rates_Analysis_GIS_Res]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP_Con_11_Rates_Analysis_GIS_Res]
AS
SELECT    (case When dbo.Reservation.Foreign_Confirm_Number is not null then dbo.Reservation.Foreign_Confirm_Number else convert(varchar(20), dbo.Reservation.Confirmation_Number) end) Confirmation_Number, 
CON.Contract_Number, 
					 (CASE WHEN CON.Contract_Number IS NOT NULL 
                      THEN CON.Vehicle_Class_Code ELSE dbo.Reservation.Vehicle_Class_Code END) AS Vehicle_Class_Code, CON.Sub_Vehicle_Class_Code, 
                      (CASE WHEN CON.Contract_Number IS NOT NULL THEN CON.Pick_Up_Location_ID ELSE dbo.Reservation.Pick_Up_Location_ID END) 
                      AS Pick_Up_Location_ID, (CASE WHEN CON.Contract_Number IS NOT NULL 
                      THEN CON.Drop_Off_Location_ID ELSE dbo.Reservation.Drop_Off_Location_ID END) AS Drop_Off_Location_ID, 
                      (CASE WHEN CON.Contract_Number IS NOT NULL THEN CON.Pick_Up_On ELSE dbo.Reservation.Pick_Up_On END) AS Pick_Up_On, 
                      (CASE WHEN CON.Contract_Number IS NOT NULL THEN CON.Drop_Off_On ELSE dbo.Reservation.Drop_Off_On END) AS Drop_Off_On, 
                      ResChgHist.ResMadeTime AS TransTime, ResCancelTime.ResCancelTime, dbo.Reservation.Status AS ResStatus, CON.Status AS Contract_status, 
                      DATEDIFF(mi, (CASE WHEN CON.Contract_Number IS NOT NULL THEN CON.Pick_Up_On ELSE dbo.Reservation.Pick_Up_On END), 
                      (CASE WHEN CON.Contract_Number IS NOT NULL THEN CON.Drop_Off_On ELSE dbo.Reservation.Drop_Off_On END)) 
                      / 1440.0 AS Contract_Rental_Days, 
                      dbo.Reservation.BCD_Number BCD_Number,
                      dbo.Reservation.BCD_Rate_Org_ID Res_Rate_Org_ID,
                      CON.BCD_Rate_Organization_ID Con_Rate_Org_ID,
                      
                      --(CASE WHEN dbo.Reservation.BCD_Number IS NOT NULL THEN dbo.Reservation.BCD_Number 
                      --WHEN dbo.Reservation.BCD_Number IS NULL AND dbo.Reservation.BCD_Rate_Org_ID IS NOT NULL 
                      --THEN org1.BCD_Number WHEN dbo.Reservation.BCD_Number IS NULL AND CON.BCD_Rate_Organization_ID IS NOT NULL THEN org2.BCD_Number END) 
                      --AS BCD_Number, 
                      dbo.RT_Rate_Amount.Rate_Name, dbo.RT_Rate_Amount.Rate_Level, SUM(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND 
                      RT_Rate_Amount.Time_Period_Start = 1) THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Daily_rate, MAX(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND 
                      RT_Rate_Amount.Time_Period_Start != 1) THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Addnl_Daily_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Week' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Weekly_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Hour' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Hourly_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Month' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Monthly_rate, 'GIS Reservation' AS Rate_Type, 
                      dbo.Reservation.IATA_Number, dbo.Reservation.First_Name, dbo.Reservation.Last_Name, ''  Book_Source, dbo.Reservation.CID,
                      dbo.Reservation.Coupon_Code,
                      dbo.Reservation.Coupon_Description, 
                      dbo.Reservation.Flex_Discount,
                      dbo.Reservation.Flat_Discount,
                      dbo.Reservation.Discount_ID,
                      dbo.Reservation.Rate_ID,
					   dbo.Reservation.Program_Number	 
                      
 
FROM				  dbo.RP__Reservation_Cancel_Time AS ResCancelTime RIGHT OUTER JOIN
                      dbo.RP__Reservation_Make_Time AS ResChgHist INNER JOIN
                      dbo.Reservation INNER JOIN
                      dbo.RT_Rate_Amount ON dbo.Reservation.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND 
                      dbo.Reservation.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND dbo.Reservation.Rate_Level = dbo.RT_Rate_Amount.Rate_Level ON 
                      ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number ON 
                      ResCancelTime.Confirmation_Number = dbo.Reservation.Confirmation_Number 
                      LEFT OUTER JOIN dbo.Contract CON                   
                      ON  dbo.Reservation.Confirmation_Number = CON.Confirmation_Number 
       
WHERE     (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.VREffectiveDate AND dbo.RT_Rate_Amount.VRTerminationDate) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RCAEffectiveDate AND dbo.RT_Rate_Amount.RCATerminationDate) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RTPEffectiveDate AND dbo.RT_Rate_Amount.RTPTerminationDate) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RVCEffectiveDate AND dbo.RT_Rate_Amount.RVCTerminationDate) AND 
                      (--dbo.Reservation.source_code<>'Maestro' or 
                      dbo.Reservation.Rate_id is not null)
GROUP BY dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number,CON.Contract_Number, ResChgHist.ResMadeTime, ResCancelTime.ResCancelTime, dbo.Reservation.Status, 
                      CON.Status, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, CON.Pick_Up_On, CON.Drop_Off_On, 
                      --dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, 
                      CON.Pick_Up_Location_ID, dbo.Reservation.Pick_Up_Location_ID, CON.Drop_Off_Location_ID, 
                      dbo.Reservation.Drop_Off_Location_ID, CON.Vehicle_Class_Code, dbo.Reservation.Vehicle_Class_Code, CON.Sub_Vehicle_Class_Code, 
                      dbo.RT_Rate_Amount.Rate_Name, dbo.Reservation.BCD_Number, dbo.RT_Rate_Amount.Rate_Level, dbo.Reservation.IATA_Number, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, 
                      --org1.BCD_Number, org2.BCD_Number, 
                      dbo.Reservation.BCD_Number,
                      dbo.Reservation.BCD_Rate_Org_ID, 
                      CON.BCD_Rate_Organization_ID, 
                      dbo.Reservation.CID,
                      dbo.Reservation.Coupon_Code,
                      dbo.Reservation.Coupon_Description, 
                      dbo.Reservation.Flex_Discount,
                      dbo.Reservation.Flat_Discount,
                      dbo.Reservation.Discount_ID,
                      dbo.Reservation.Rate_ID,
					   dbo.Reservation.Program_Number	--,
                      --cci.UpgradeCharge
                      
 
                      
                      
                      --select distinct source_code from Reservation
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
         Begin Table = "ResCancelTime"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ResChgHist"
            Begin Extent = 
               Top = 6
               Left = 276
               Bottom = 84
               Right = 476
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
            TopColumn = 12
         End
         Begin Table = "RT_Rate_Amount"
            Begin Extent = 
               Top = 192
               Left = 38
               Bottom = 300
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract"
            Begin Extent = 
               Top = 300
               Left = 38
               Bottom = 408
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 408
               Left = 38
               Bottom = 516
               Right = 293
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
      Be' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_GIS_Res'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'gin ColumnWidths = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_GIS_Res'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_GIS_Res'
GO
