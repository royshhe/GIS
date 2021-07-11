USE [GISData]
GO
/****** Object:  View [dbo].[IRACS_EFT_Contract_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IRACS_EFT_Contract_vw]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, dbo.Contract.Address_1, dbo.Contract.Address_2, dbo.Contract.City, 
                      dbo.Contract.Province_State, dbo.Contract.Postal_Code, dbo.Contract.Phone_Number, dbo.Contract.Gender, dbo.Contract.Birth_Date, 
                      dbo.Contract.Customer_Program_Number, dbo.Contract.Renter_Driving
FROM         dbo.Contract INNER JOIN
                      dbo.Location LocationOut ON dbo.Contract.Pick_Up_Location_ID = LocationOut.Location_ID INNER JOIN
                      dbo.Location LocationIn ON dbo.Contract.Drop_Off_Location_ID = LocationIn.Location_ID INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number LEFT OUTER JOIN
                      dbo.Contract_Additional_Driver ON dbo.Contract.Contract_Number = dbo.Contract_Additional_Driver.Contract_Number
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[55] 4[6] 2[20] 3) )"
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
         Begin Table = "Contract"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 355
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "LocationOut"
            Begin Extent = 
               Top = 209
               Left = 673
               Bottom = 317
               Right = 914
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LocationIn"
            Begin Extent = 
               Top = 278
               Left = 349
               Bottom = 386
               Right = 590
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 6
               Left = 712
               Bottom = 114
               Right = 951
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 6
               Left = 989
               Bottom = 114
               Right = 1215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract_Additional_Driver"
            Begin Extent = 
               Top = 78
               Left = 500
               Bottom = 186
               Right = 709
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
   Begin Cri' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IRACS_EFT_Contract_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'teriaPane = 
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IRACS_EFT_Contract_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IRACS_EFT_Contract_vw'
GO
