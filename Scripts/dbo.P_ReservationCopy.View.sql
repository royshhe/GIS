USE [GISData]
GO
/****** Object:  View [dbo].[P_ReservationCopy]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[P_ReservationCopy]
AS
SELECT     dbo.P_Reservation.Confirmation_Number, 

(Case When dbo.P_Reservation.Foreign_Confirm_Number is not null then dbo.P_Reservation.Foreign_Confirm_Number Else  'G'+Convert(Varchar(12), dbo.P_Reservation.Confirmation_Number) End) Foreign_Confirm_Number, 

dbo.P_Reservation.Marketing_Source_ID, 
                      dbo.P_Reservation.Credit_Card_Type_ID, dbo.P_Reservation.Drop_Off_Location_ID, dbo.P_Reservation.Pick_Up_Location_ID, 
                      dbo.P_Reservation.Vehicle_Class_Code, dbo.P_Reservation.Pick_Up_On, dbo.P_Reservation.Drop_Off_On, dbo.P_Reservation.Smoking_Non_Smoking, 
                      dbo.P_Reservation.Flight_Number, dbo.P_Reservation.IATA_Number, dbo.P_Reservation.First_Name, dbo.P_Reservation.Last_Name, 
                      dbo.P_Reservation.Business_Phone_Number, dbo.P_Reservation.Contact_Phone_Number, dbo.P_Reservation.Payment_Method, 
                      dbo.P_Reservation.Deposit_Method, dbo.P_Reservation.Flex_Discount, dbo.P_Reservation.Special_Comments, dbo.P_Reservation.Customer_ID, 
                      dbo.P_Reservation.Referring_Employee_ID, dbo.P_Reservation.Discount_ID, dbo.P_Reservation.Rate_Level, dbo.P_Reservation.Rate_ID, 
                      dbo.P_Reservation.Date_Rate_Assigned, dbo.P_Reservation.Status, dbo.P_Reservation.Cancellation_Reason, dbo.P_Reservation.Fax_Number, 
                      dbo.P_Reservation.Fax_Confirmation, dbo.P_Reservation.Deposit_Waived, dbo.P_Reservation.Maestro_Guarantee, dbo.P_Reservation.Copied, 
                      dbo.P_Reservation.PrePay_Indicator, dbo.P_Reservation.Executive_Action_Indicator, dbo.P_Reservation.BCD_Rate_Org_ID, dbo.P_Reservation.Referring_Org_ID, 
                      dbo.P_Reservation.Program_Number, dbo.P_Reservation.Source_Code, dbo.P_Reservation.Fastbreak_Indicator, dbo.P_Reservation.Applicant_Status_Indicator, 
                      dbo.P_Reservation.Perfect_Drive_Indicator, dbo.P_Reservation.Guaranteed_Rate_Indicator, dbo.P_Reservation.Guarantee_Credit_Card_Key, 
                      dbo.P_Reservation.Company_Name, dbo.P_Reservation.Update_Ctrl, dbo.P_Reservation.Last_Changed_By, dbo.P_Reservation.Last_Changed_On, 
                      dbo.P_Reservation.Quoted_Rate_ID, dbo.P_Reservation.Affiliated_BCD_Org_ID, dbo.P_Reservation.Guarantee_Deposit_Amount, dbo.P_Reservation.Customer_Code, 
                      dbo.P_Reservation.Swiped_Flag, dbo.P_Reservation.Email_Address, dbo.P_Reservation.BCD_Number, dbo.P_Reservation.Coupon_Code, 
                      PLOC.Mnemonic_Code AS PUCode, DLOC.Mnemonic_Code AS DOCode, dbo.P_Organization.BCD_Number AS RateBCD, dbo.VC_Mapping.VC_Code, 
                      dbo.P_Vehicle_Rate.Rate_Name
FROM         dbo.P_Reservation INNER JOIN
                      dbo.P_Location AS DLOC ON dbo.P_Reservation.Drop_Off_Location_ID = DLOC.Location_ID INNER JOIN
                      dbo.P_Location AS PLOC ON dbo.P_Reservation.Pick_Up_Location_ID = PLOC.Location_ID INNER JOIN
                      dbo.P_Vehicle_Rate ON dbo.P_Reservation.Rate_ID = dbo.P_Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.VC_Mapping ON dbo.P_Reservation.Vehicle_Class_Code = dbo.VC_Mapping.P_VC_Code LEFT OUTER JOIN
                      dbo.P_Organization ON dbo.P_Reservation.BCD_Rate_Org_ID = dbo.P_Organization.Organization_ID

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[13] 2[42] 3) )"
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
         Begin Table = "P_Reservation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 259
               Right = 266
            End
            DisplayFlags = 280
            TopColumn = 43
         End
         Begin Table = "DLOC"
            Begin Extent = 
               Top = 0
               Left = 404
               Bottom = 198
               Right = 654
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "PLOC"
            Begin Extent = 
               Top = 115
               Left = 380
               Bottom = 232
               Right = 630
            End
            DisplayFlags = 280
            TopColumn = 30
         End
         Begin Table = "P_Vehicle_Rate"
            Begin Extent = 
               Top = 69
               Left = 733
               Bottom = 273
               Right = 980
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VC_Mapping"
            Begin Extent = 
               Top = 216
               Left = 275
               Bottom = 303
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P_Organization"
            Begin Extent = 
               Top = 153
               Left = 426
               Bottom = 270
               Right = 665
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
         Column = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'P_ReservationCopy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1440
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'P_ReservationCopy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'P_ReservationCopy'
GO
