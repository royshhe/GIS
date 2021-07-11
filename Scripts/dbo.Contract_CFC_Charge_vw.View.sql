USE [GISData]
GO
/****** Object:  View [dbo].[Contract_CFC_Charge_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Contract_CFC_Charge_vw]
AS

SELECT
			RBR_Date, 
			contract_number,
			(Case When Contract_Rental_Days<=7 Then SUM(Amount)/5 
				When Contract_Rental_Days>7 Then 8
			End	) RentalDays,
			SUM(Amount) CFCAmount  
						
			FROM 
			
			(
			SELECT bt.RBR_Date, c.Pick_Up_On, bt.Contract_Number, dbo.GetChargeRentalDays(DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In)) AS Contract_Rental_Days, 
               cci.Amount - cci.GST_Amount_Included - cci.PST_Amount_Included - cci.PVRT_Amount_Included AS Amount
				FROM  dbo.Contract AS c WITH (NOLOCK) INNER JOIN
							   dbo.Contract_Charge_Item AS cci ON c.Contract_Number = cci.Contract_Number INNER JOIN
							   dbo.Location AS PULoc ON c.Pick_Up_Location_ID = PULoc.Location_ID INNER JOIN
							   dbo.Location AS DOLoc ON c.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
							   dbo.Business_Transaction AS bt ON bt.Contract_Number = c.Contract_Number INNER JOIN
							   dbo.RP__Last_Vehicle_On_Contract AS rlv ON c.Contract_Number = rlv.Contract_Number
				WHERE (bt.Transaction_Type = 'con') 
					AND (bt.Transaction_Description IN ('check in')) 
					AND (c.Status = 'CI') 
					AND (cci.Charge_Type = 39) 
					AND (cci.Charge_Item_type = 'c') 
					AND (PULoc.Owning_Company_ID = 7425)
			
			)
			 Con	
		--where --rbr_date >='2017-09-01' and rbr_date<'2017-10-01' and Pick_Up_On>='2017-09-01'
		--and Charge_Type=39

		GROUP BY RBR_Date,
			contract_number,	
		Contract_Rental_Days
		



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
         Begin Table = "c"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 148
               Right = 306
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cci"
            Begin Extent = 
               Top = 7
               Left = 354
               Bottom = 148
               Right = 623
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PULoc"
            Begin Extent = 
               Top = 154
               Left = 48
               Bottom = 295
               Right = 331
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DOLoc"
            Begin Extent = 
               Top = 154
               Left = 379
               Bottom = 295
               Right = 662
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bt"
            Begin Extent = 
               Top = 301
               Left = 48
               Bottom = 442
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rlv"
            Begin Extent = 
               Top = 301
               Left = 333
               Bottom = 442
               Right = 610
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
         Table =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_CFC_Charge_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_CFC_Charge_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_CFC_Charge_vw'
GO
