USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_Contract_Billing_Party]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Adhoc_Contract_Billing_Party]
AS
SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, DropOffLoc.Location AS DropOffLocatioin, 
                      PickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, 
                      dbo.Quoted_Vehicle_Rate.Rate_Name AS Res_Maestro_rate, ResGISRate.Rate_Name AS Res_GIS_Rate, 
                      dbo.Quoted_Vehicle_Rate.Authorized_DO_Charge AS DropOffCharge, ResChgHist.ResMadeTime, dbo.Reservation.Status, 
                      dbo.Contract.Contract_Number, dbo.Vehicle_Rate.Rate_Name AS GISRate, dbo.Contract_Billing_Party.Billing_Type, 
                      dbo.Contract_Billing_Party.Billing_Method, dbo.Contract_Billing_Party.Customer_Code
FROM         dbo.Organization INNER JOIN
                      dbo.Reservation ON dbo.Organization.BCD_Number = dbo.Reservation.BCD_Number LEFT OUTER JOIN
                      dbo.Contract_Billing_Party INNER JOIN
                      dbo.Contract ON dbo.Contract_Billing_Party.Contract_Number = dbo.Contract.Contract_Number INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Contract.Rate_ID = dbo.Vehicle_Rate.Rate_ID AND dbo.Contract.Rate_Assigned_Date BETWEEN 
                      dbo.Vehicle_Rate.Effective_Date AND dbo.Vehicle_Rate.Termination_Date ON 
                      dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number LEFT OUTER JOIN
                      dbo.Vehicle_Rate ResGISRate ON dbo.Reservation.Rate_ID = ResGISRate.Rate_ID AND dbo.Reservation.Date_Rate_Assigned BETWEEN 
                      ResGISRate.Effective_Date AND ResGISRate.Termination_Date LEFT OUTER JOIN
                      dbo.Location DropOffLoc ON dbo.Reservation.Drop_Off_Location_ID = DropOffLoc.Location_ID LEFT OUTER JOIN
                      dbo.Location PickupLoc ON dbo.Reservation.Pick_Up_Location_ID = PickupLoc.Location_ID LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.RP__Reservation_Make_Time ResChgHist ON ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number
WHERE     (dbo.Reservation.Status = 'A' OR
                      dbo.Reservation.Status = 'O') AND (dbo.Organization.Tour_Rate_Account = 1)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[12] 2[38] 3) )"
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
         Begin Table = "ResGISRate"
            Begin Extent = 
               Top = 0
               Left = 17
               Bottom = 115
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 29
               Left = 547
               Bottom = 232
               Right = 767
            End
            DisplayFlags = 280
            TopColumn = 52
         End
         Begin Table = "Contract_Billing_Party"
            Begin Extent = 
               Top = 4
               Left = 938
               Bottom = 119
               Right = 1183
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract"
            Begin Extent = 
               Top = 262
               Left = 629
               Bottom = 476
               Right = 845
            End
            DisplayFlags = 280
            TopColumn = 31
         End
         Begin Table = "Vehicle_Rate"
            Begin Extent = 
               Top = 108
               Left = 1221
               Bottom = 223
               Right = 1460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DropOffLoc"
            Begin Extent = 
               Top = 221
               Left = 0
               Bottom = 336
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PickupLoc"
            Begin Extent = 
               Top = 283
               Left = 274
               Bottom = 398
               Right = 516
           ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Adhoc_Contract_Billing_Party'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Quoted_Vehicle_Rate"
            Begin Extent = 
               Top = 227
               Left = 462
               Bottom = 342
               Right = 701
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ResChgHist"
            Begin Extent = 
               Top = 0
               Left = 530
               Bottom = 85
               Right = 715
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Organization"
            Begin Extent = 
               Top = 48
               Left = 823
               Bottom = 163
               Right = 1054
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Adhoc_Contract_Billing_Party'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Adhoc_Contract_Billing_Party'
GO
