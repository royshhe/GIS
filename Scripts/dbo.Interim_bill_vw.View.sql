USE [GISData]
GO
/****** Object:  View [dbo].[Interim_bill_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Interim_bill_vw]
AS
SELECT
	dbo.Contract.Email_address, 
	dbo.Contract_Payment_Item.RBR_Date, 
	dbo.Interim_Bill.Contract_Number, 
	dbo.Interim_Bill.Interim_Bill_Date, 
	dbo.Interim_Bill.Contract_Billing_Party_Id,
	dbo.Contract_Payment_Item.Amount, 
    dbo.Interim_Bill.Current_KM,
    dbo.Contract_Payment_Item.Business_transaction_id,
	dbo.Interim_Bill.Coverage_amount,
	cvpst.PST/100 as PST
FROM  dbo.Contract Inner Join
dbo.Contract_Payment_Item  
on dbo.Contract.Contract_number=  dbo.Contract_Payment_Item.Contract_Number
INNER JOIN dbo.AR_Payment 
	ON dbo.Contract_Payment_Item.Contract_Number = dbo.AR_Payment.Contract_Number 
	AND  dbo.Contract_Payment_Item.Sequence = dbo.AR_Payment.Sequence 
INNER JOIN dbo.Interim_Bill 
	ON dbo.AR_Payment.Contract_Number = dbo.Interim_Bill.Contract_Number 
	AND dbo.AR_Payment.Contract_Billing_Party_ID = dbo.Interim_Bill.Contract_Billing_Party_ID 
	AND dbo.AR_Payment.Interim_Bill_Date = dbo.Interim_Bill.Interim_Bill_Date
 Left join dbo.Contract_Vehicle_PST_Rate_vw CVPST
				on CVPST.contract_number=dbo.Contract.Contract_number
						and dbo.Interim_Bill.Interim_Bill_Date between CVPST.PickUpDate and CVPST.DropOffDate
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
         Begin Table = "Contract_Payment_Item"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 287
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Payment"
            Begin Extent = 
               Top = 7
               Left = 335
               Bottom = 148
               Right = 573
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Interim_Bill"
            Begin Extent = 
               Top = 7
               Left = 621
               Bottom = 148
               Right = 859
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Interim_bill_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Interim_bill_vw'
GO
