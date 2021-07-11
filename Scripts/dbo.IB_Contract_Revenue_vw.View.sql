USE [GISData]
GO
/****** Object:  View [dbo].[IB_Contract_Revenue_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
VIEW NAME: IB_Contract_Revenue_vw
PURPOSE: Get All the Contract Reveunes based contrct number, rbr_date, and Unit_number
	 
AUTHOR:	
DATE CREATED:
USED BY:
MOD HISTORY:
Name 		Date		Comments
*/


CREATE VIEW [dbo].[IB_Contract_Revenue_vw]
AS
SELECT  dbo.IB_Contracts_vw.Contract_Number , 
	dbo.Business_Transaction.RBR_Date, 
	dbo.IB_Contracts_vw.Vehicle_Class_Code,
	dbo.IB_Contracts_vw.Unit_Number, 
	dbo.IB_Contracts_vw.Owning_Company_ID Vehicle_Ownership,
	dbo.IB_Contracts_vw.Pick_Up_Location_ID Pickup_Location, 
	dbo.IB_Contracts_vw.Actual_Drop_Off_Location_ID Dropoff_Location, 
	dbo.IB_Contracts_vw.Contract_Currency_ID, 
	dbo.IB_Contracts_vw.LOR_Percentage, 	 
	(CASE 
		WHEN dbo.Optional_Extra_GL.GL_Revenue_Account IS NOT NULL 
		THEN dbo.Optional_Extra_GL.GL_Revenue_Account 
		ELSE dbo.Charge_GL.GL_Revenue_Account 
	END) AS Revenue_Account, 

            ( CASE 
		when dbo.Contract_Charge_Item.Charge_Type<>18 then
			CONVERT(DECIMAL(9, 2),
				CONVERT(DECIMAL(11, 4), 
				dbo.Contract_Charge_Item.Amount 	
				- dbo.Contract_Charge_Item.GST_Amount_Included
				- dbo.Contract_Charge_Item.PST_Amount_Included 
				- dbo.Contract_Charge_Item.PVRT_Amount_Included
				
				)*
				CONVERT(DECIMAL(11, 4),dbo.Exchange_Rate.Rate)*
				CONVERT(DECIMAL(11, 4),dbo.IB_Contracts_vw.LOR_Percentage)
		 	) 
		else
			CONVERT(DECIMAL(9, 2),
				--CONVERT(DECIMAL(11, 4), dbo.Contract_Charge_Item.Amount)*
				CONVERT(DECIMAL(11, 4), 
				dbo.Contract_Charge_Item.Amount 	
				- dbo.Contract_Charge_Item.GST_Amount_Included
				- dbo.Contract_Charge_Item.PST_Amount_Included 
				- dbo.Contract_Charge_Item.PVRT_Amount_Included
				
				)*			
				CONVERT(DECIMAL(11, 4),dbo.IB_Contracts_vw.LOR_Percentage)			
			)  
	 end
	)

	as Amount
FROM    
		dbo.Contract_Charge_Item 
		INNER JOIN
		dbo.Business_Transaction 
			ON dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID 
		INNER JOIN
		dbo.IB_Contracts_vw 
			ON dbo.Contract_Charge_Item.Contract_Number = dbo.IB_Contracts_vw.Contract_Number 
		
		INNER JOIN
		dbo.Exchange_Rate 
			ON dbo.IB_Contracts_vw.Contract_Currency_ID = dbo.Exchange_Rate.Currency_ID
        INNER JOIN
		dbo.Vehicle_Class
			On dbo.IB_Contracts_vw.Vehicle_Class_Code= dbo.Vehicle_Class.Vehicle_Class_Code
		
		LEFT OUTER JOIN
		dbo.Optional_Extra_GL 
			ON dbo.Contract_Charge_Item.Optional_Extra_ID = dbo.Optional_Extra_GL.Optional_Extra_ID
				 And dbo.Vehicle_Class.Vehicle_Type_ID=dbo.Optional_Extra_GL.Vehicle_Type_ID
		LEFT OUTER JOIN
		dbo.Charge_GL 
			ON dbo.Contract_Charge_Item.Charge_Type = dbo.Charge_GL.Charge_Type_ID AND dbo.Charge_GL.Vehicle_Type_ID=dbo.Vehicle_Class.Vehicle_Type_ID
Where dbo.Business_Transaction.RBR_Date between dbo.Exchange_Rate.Exchange_Rate_Valid_From and ISNULL(dbo.Exchange_Rate.Valid_To,Convert(DateTime, 'Dec 31 2078'))


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[57] 4[3] 2[25] 3) )"
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
         Begin Table = "Contract_Charge_Item"
            Begin Extent = 
               Top = 128
               Left = 274
               Bottom = 487
               Right = 500
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "glchart_OptionalExtra"
            Begin Extent = 
               Top = 52
               Left = 1117
               Bottom = 160
               Right = 1293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Optional_Extra_GL"
            Begin Extent = 
               Top = 22
               Left = 819
               Bottom = 115
               Right = 1005
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "glchart_Charge"
            Begin Extent = 
               Top = 198
               Left = 896
               Bottom = 306
               Right = 1072
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Charge_GL"
            Begin Extent = 
               Top = 251
               Left = 576
               Bottom = 344
               Right = 762
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Business_Transaction"
            Begin Extent = 
               Top = 379
               Left = 767
               Bottom = 502
               Right = 967
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IB_Contracts"
            Begin Extent = 
               Top = 50
               Left = 0
               Bottom = 228
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IB_Contract_Revenue_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Exchange_Rate"
            Begin Extent = 
               Top = 317
               Left = 58
               Bottom = 425
               Right = 272
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
         Column = 1755
         Alias = 1875
         Table = 1530
         Output = 1065
         Append = 1400
         NewValue = 1170
         SortType = 1395
         SortOrder = 1140
         GroupBy = 1350
         Filter = 1620
         Or = 1650
         Or = 1560
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IB_Contract_Revenue_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IB_Contract_Revenue_vw'
GO
