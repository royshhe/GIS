USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_11_Rates_Analysis_GIS_Walkup]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP_Con_11_Rates_Analysis_GIS_Walkup]
AS
SELECT     Convert(Varchar(20), dbo.Contract.Confirmation_Number) Confirmation_Number, dbo.Contract.Contract_Number, dbo.Contract.Vehicle_Class_Code, dbo.Contract.Sub_Vehicle_Class_Code, 
                      dbo.Contract.Pick_Up_Location_ID, dbo.Contract.Drop_Off_Location_ID, dbo.Contract.Pick_Up_On, dbo.Contract.Drop_Off_On, 
                      dbo.Contract.Rate_Assigned_Date AS TransTime, NULL AS ResCancelTime, NULL AS ResStatus, dbo.Contract.Status AS Contract_status, DATEDIFF(mi, 
                      dbo.Contract.Pick_Up_On, dbo.Contract.Drop_Off_On) / 1440.0 AS Contract_Rental_Days, 
                      dbo.Reservation.BCD_Number,  
                      dbo.Reservation.BCD_Rate_Org_ID Res_Rate_Org_ID,
                      dbo.Contract.BCD_Rate_Organization_ID Con_Rate_Org_ID,
                      dbo.RT_Rate_Amount.Rate_Name, dbo.RT_Rate_Amount.Rate_Level, SUM(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND 
                      RT_Rate_Amount.Time_Period_Start = 1) THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Daily_rate, 
                      MAX(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND RT_Rate_Amount.Time_Period_Start != 1) THEN RT_Rate_Amount.Amount ELSE 0.0 END)
                       AS Addnl_Daily_rate, SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Week' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Weekly_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Hour' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Hourly_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Month' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Monthly_rate, 'Walk Up' AS Rate_Type, 
                      dbo.Reservation.IATA_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, ''  Book_Source, dbo.Reservation.CID,
                      dbo.Reservation.Coupon_Code,
                      dbo.Reservation.Coupon_Description, 
                      dbo.Reservation.Flex_Discount,
                      dbo.Reservation.Flat_Discount,
                      dbo.Reservation.Discount_ID,
					   dbo.Reservation.Program_Number	--,
                      --cci.UpgradeCharge
 
FROM         dbo.Contract INNER JOIN
                      dbo.RT_Rate_Amount ON dbo.Contract.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND 
                      dbo.Contract.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND dbo.Contract.Rate_Level = dbo.RT_Rate_Amount.Rate_Level 
                      
                      LEFT JOIN dbo.Reservation 
							ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number
 
WHERE     (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.VREffectiveDate AND dbo.RT_Rate_Amount.VRTerminationDate) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.RCAEffectiveDate AND dbo.RT_Rate_Amount.RCATerminationDate) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.RTPEffectiveDate AND dbo.RT_Rate_Amount.RTPTerminationDate) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.RVCEffectiveDate AND dbo.RT_Rate_Amount.RVCTerminationDate) AND 
                      (dbo.Contract.Confirmation_Number IS NULL)
GROUP BY dbo.Contract.Confirmation_Number, dbo.Contract.Contract_Number, dbo.Contract.Rate_Assigned_Date, dbo.Contract.Vehicle_Class_Code, 
                      dbo.Contract.Sub_Vehicle_Class_Code, dbo.Contract.Pick_Up_Location_ID, dbo.Contract.Drop_Off_Location_ID, dbo.Contract.Pick_Up_On, 
                      dbo.Contract.Drop_Off_On, dbo.Contract.Status,  dbo.Reservation.BCD_Number, 
                       dbo.Reservation.BCD_Rate_Org_ID, 
                      dbo.Contract.BCD_Rate_Organization_ID, 
                      dbo.RT_Rate_Amount.Rate_Name, dbo.RT_Rate_Amount.Rate_Level, dbo.Reservation.IATA_Number, dbo.Contract.First_Name, 
                      dbo.Contract.Last_Name, dbo.Reservation.CID,
                      dbo.Reservation.Coupon_Code,
                      dbo.Reservation.Coupon_Description, 
                      dbo.Reservation.Flex_Discount,
                      dbo.Reservation.Flat_Discount,
                      dbo.Reservation.Discount_ID,
					   dbo.Reservation.Program_Number	 -- ,
                     -- cci.UpgradeCharge
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
         Begin Table = "Contract"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "RT_Rate_Amount"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_GIS_Walkup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_Con_11_Rates_Analysis_GIS_Walkup'
GO
