USE [GISData]
GO
/****** Object:  View [dbo].[Location_Production_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Location_Production_vw]
AS
SELECT Location_ID, Location, Owning_Company_ID, Hub_ID, Address_1, Address_2, City, Province, Postal_Code, Fax_Number, Phone_Number, Grace_Period, Manager, 
               Remarks, Address_Description, Hours_of_Service_Description, Corporate_Location_ID, Percentage_Fee, Flat_Fee, GIS_Member, Fuel_Price_Per_Liter, 
               Fuel_Price_Per_Liter_Diesel, FPO_Fuel_Price_Per_Liter, FPO_Fuel_Price_Per_Liter_Dsel, Default_Unauthorized_charge, Rental_Location, ResNet, Delete_Flag, 
               Fee_Type, Mnemonic_Code, Platinum_Territory_Code, AR_Forced_Charge_Account, GL_Fees_Payable_Clear_Account, Version, Last_Updated_By, 
               Last_Updated_On, TruckInv_Last_Updated_By, TruckInv_Last_Updated_On, LicenseFeePerDay, LicenseFeePercentage, LicenseFeeFlat, AllowResForOther, 
               BroadcastMssg, LocationName, SearchKeyWord, IsAirportLocation, LocationDescription, Country, StationNumber, CounterCode, GDSCode, LocalHubOnly, 
               LocalCompanyOnly, DBRCode, IB_Zone, Merchant_ID, Sell_Online, CSA, Acctg_Segment, Email_Hour_Description, Payment_Processing, IBX_Code, 
               SunnyCloudyLocName, SunnyCloudyCode, Merchant_Name, TK_CounterCode, TK_Mnemonic_Code, TK_StationNumber, TK_DBRCode, Truck_Location, 
               Car_Location, District, OnlineImage_big, OnlineImage_small, MapImage_small, Latitude, Longitude, Nearby_Airport_location
FROM  dbo.Location
WHERE (Location_ID IN (228, 256, 255))
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
         Begin Table = "Location"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 331
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Location_Production_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Location_Production_vw'
GO
