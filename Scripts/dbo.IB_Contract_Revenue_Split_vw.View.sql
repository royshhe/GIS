USE [GISData]
GO
/****** Object:  View [dbo].[IB_Contract_Revenue_Split_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
VIEW NAME: IB_Contract_Revenue_vw
PURPOSE:Split Reveunes according to Transaction type, IB Zone
	 
AUTHOR:	
DATE CREATED:
USED BY:
MOD HISTORY:
Name 		Date		Comments
*/


CREATE VIEW [dbo].[IB_Contract_Revenue_Split_vw]
AS
SELECT     IB_Con_Revenue.Contract_number, IB_Con_Revenue.RBR_Date, IB_Con_Revenue.Vehicle_Owner_IB_Zone, 
                      IB_Con_Revenue.Vehicle_Owner_Company, IB_Con_Revenue.Renting_Compay, IB_Con_Revenue.Receiving_Company, 
                      dbo.IsLocalComapy(IB_Con_Revenue.Vehicle_Owner_Company) AS Owned_By_Me, dbo.IsLocalComapy(IB_Con_Revenue.Renting_Compay) 
                      AS Rented_By_Me, dbo.IsLocalComapy(IB_Con_Revenue.Receiving_Company) AS Received_By_Me, IB_Con_Revenue.Transaction_Type, 
                      IB_Con_Revenue.IB_Zone, dbo.IB_Revenue_Split.Revenue_Account, dbo.IB_Revenue_Split.Revenue_Ownership, 
                      dbo.IB_Revenue_Split.Commission_Rate, IB_Con_Revenue.Amount, IB_Con_Revenue.Vehicle_Ownership_Vendor_Code, 
                      IB_Con_Revenue.Vehicle_Ownership_Customer_code, IB_Con_Revenue.Renting_Compay_Vendor_Code, 
                      IB_Con_Revenue.Renting_Compay_Customer_Code, IB_Con_Revenue.Receiving_Company_Vendor_Code, 
                      IB_Con_Revenue.Receiving_Company_Customer_Code,
                      IB_Con_Revenue.Contract_Currency_ID
FROM         dbo.IB_Revenue_Split INNER JOIN
                      dbo.IB_Contract_Revenue_Type_Zone_vw IB_Con_Revenue ON dbo.IB_Revenue_Split.Transaction_Type = IB_Con_Revenue.Transaction_Type AND 
                      dbo.IB_Revenue_Split.IB_Zone = IB_Con_Revenue.IB_Zone AND dbo.IB_Revenue_Split.Revenue_Account = IB_Con_Revenue.Revenue_Account



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[11] 2[23] 3) )"
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
         Begin Table = "IB_Revenue_Split"
            Begin Extent = 
               Top = 34
               Left = 716
               Bottom = 315
               Right = 993
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IB_Con_Revenue"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 365
               Right = 298
            End
            DisplayFlags = 280
            TopColumn = 1
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IB_Contract_Revenue_Split_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IB_Contract_Revenue_Split_vw'
GO
