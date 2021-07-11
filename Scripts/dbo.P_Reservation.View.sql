USE [GISData]
GO
/****** Object:  View [dbo].[P_Reservation]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Reservation]
AS
SELECT     Confirmation_Number, Foreign_Confirm_Number, Marketing_Source_ID, Credit_Card_Type_ID, 
                      (CASE WHEN Drop_Off_Location_ID = 7 THEN 6 ELSE Drop_Off_Location_ID END) AS Drop_Off_Location_ID, 
                      (CASE WHEN Pick_Up_Location_ID = 7 THEN 6 ELSE Pick_Up_Location_ID END) AS Pick_Up_Location_ID, Vehicle_Class_Code, Pick_Up_On, Drop_Off_On, 
                      Smoking_Non_Smoking, Flight_Number, IATA_Number, First_Name, Last_Name, Business_Phone_Number, Contact_Phone_Number, Payment_Method, 
                      Deposit_Method, Flex_Discount, Special_Comments, Customer_ID, Referring_Employee_ID, Discount_ID, Rate_Level, Rate_ID, Date_Rate_Assigned, Status, 
                      Cancellation_Reason, Fax_Number, Fax_Confirmation, Deposit_Waived, Maestro_Guarantee, Copied, PrePay_Indicator, Executive_Action_Indicator, 
                      BCD_Rate_Org_ID, Referring_Org_ID, Program_Number, Source_Code, Fastbreak_Indicator, Applicant_Status_Indicator, Perfect_Drive_Indicator, 
                      Guaranteed_Rate_Indicator, Guarantee_Credit_Card_Key, Company_Name, Update_Ctrl, Last_Changed_By, Last_Changed_On, Quoted_Rate_ID, 
                      Affiliated_BCD_Org_ID, Guarantee_Deposit_Amount, Customer_Code, Swiped_Flag, Email_Address, BCD_Number, Coupon_Code
FROM         svbvm032.Geordydata.dbo.Reservation AS Reservation
WHERE     (Pick_Up_Location_ID IN (10)) AND (Status = 'A') AND (Source_Code Not IN ('Maestro')) and Pick_Up_On>='2011-12-15'
		or
 (Pick_Up_Location_ID IN (12)) AND (Status = 'A') AND (Source_Code Not IN ('Maestro')) and Pick_Up_On>='2011-12-15'


--select * from svbvm032.Geordydata.dbo.location
--
--A-06 Kingsway
--A-07 Kingsway Prod
--A-12 North Vanc.
--A-13 Richmond
--10 for burnaby
--12 for production
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[11] 2[41] 3) )"
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
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 123
               Right = 266
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'P_Reservation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'P_Reservation'
GO
