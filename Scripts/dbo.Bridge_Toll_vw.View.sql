USE [GISData]
GO
/****** Object:  View [dbo].[Bridge_Toll_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [Bridge_Toll_vw] where rbr_date='2013-02-27'

CREATE VIEW [dbo].[Bridge_Toll_vw]
AS
SELECT     dbo.Contract.Contract_Number, 
			dbo.Contract.First_Name, 
			dbo.Contract.Last_Name, 
			dbo.Contract.Gender, 
			dbo.Contract.Address_1, 
			dbo.Contract.Address_2, 
			dbo.Contract.City, 
			dbo.Contract.Province_State, 
			dbo.Contract.Postal_Code, 
			dbo.Lookup_Table.Value AS Country, 
			SUM(CASE WHEN charge_type = 48 THEN dbo.Contract_Charge_Item.Amount ELSE 0 END) AS ViolationCharge, 
			SUM(CASE WHEN charge_type = 49 THEN dbo.Contract_Charge_Item.Amount ELSE 0 END) AS AdminCharge, 
			MAX(dbo.Contract_Charge_Item.Ticket_Number) AS TicketNumber, 
			lt1.value AS Issuer, 
			MAX(dbo.Contract_Charge_Item.Issuing_Date) AS Issue_Date, 
			MAX(dbo.Contract_Charge_Item.License_Number) AS License_Number, 
			bt.RBR_Date, 
			bt.Business_Transaction_ID, 
			dbo.Contract_Billing_Party.Billing_Method, 
			dbo.Contract.Pick_Up_On AS Pickup_Date, 
			(Case When dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In is Null 
				 Then bt.transaction_date
				 Else  dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In
				 End) 				 
			AS Dropoff_Date,
			(Case When dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In is Null 
				 Then dbo.Contract.Drop_Off_On
				 Else  dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In
				 End) 				 
			AS Return_Date,				
			bt.transaction_date,
			bt.Transaction_Description,
			dbo.Contract.Status,
			dbo.Contract_Charge_Item.Issuer as IssuerCode	
FROM        dbo.Contract 
			INNER JOIN dbo.Contract_Charge_Item 
				ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number 			
			INNER JOIN dbo.Contract_Billing_Party 
				ON dbo.Contract_Charge_Item.Contract_Number = dbo.Contract_Billing_Party.Contract_Number 
				AND dbo.Contract_Charge_Item.Contract_Billing_Party_ID = dbo.Contract_Billing_Party.Contract_Billing_Party_ID 
			INNER JOIN dbo.Lookup_Table 		
				ON dbo.Contract.Country = dbo.Lookup_Table.Code AND dbo.Lookup_Table.Category = 'Country' 
			INNER JOIN dbo.RP__Last_Vehicle_On_Contract 
				ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number
			Inner JOIN dbo.Business_Transaction bt
				ON dbo.Contract_Charge_Item.Business_Transaction_ID = bt.Business_Transaction_ID 
			--LEFT JOIN 
			--	(	Select   Business_transaction_ID, Email_Sent from dbo.Toll_Charge
			--		where	 Business_transaction_ID is not  null
			--		Group by Business_transaction_ID,Email_Sent	 
			
			--	) TC 
			--	on
			--	bt.Business_Transaction_ID = TC.Business_Transaction_ID 
			
			LEFT JOIN lookup_table lt1 
				on lt1.category='Toll Charge Issuer' and lt1.code=dbo.Contract_Charge_Item.Issuer

WHERE     (dbo.Contract_Charge_Item.Charge_Type IN (48, 49))
		  --And (TC.Email_Sent=0 or  TC.Email_Sent is Null)	
		 
GROUP BY dbo.Contract.Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, dbo.Contract.Gender, dbo.Contract.Address_1, dbo.Contract.Address_2, 
                      dbo.Contract.City, dbo.Contract.Province_State, dbo.Contract.Postal_Code, dbo.Lookup_Table.Value, bt.RBR_Date, 
                      bt.Business_Transaction_ID, dbo.Contract_Billing_Party.Billing_Method, dbo.Contract.Pick_Up_On, dbo.Contract.Drop_Off_On,
                      dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In,lt1.value,bt.transaction_date,bt.Transaction_Description,
                      dbo.Contract.Status,	dbo.Contract_Charge_Item.Issuer
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
               Bottom = 125
               Right = 278
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 289
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Business_Transaction"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contract_Billing_Party"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 485
               Right = 307
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lookup_Table"
            Begin Extent = 
               Top = 246
               Left = 301
               Bottom = 365
               Right = 477
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RP__Last_Vehicle_On_Contract"
            Begin Extent = 
               Top = 114
               Left = 440
               Bottom = 317
               Right = 702
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
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Bridge_Toll_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Bridge_Toll_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Bridge_Toll_vw'
GO
