USE [GISData]
GO
/****** Object:  View [dbo].[RP_CCI_3_Credit_Card_Balancing_Payment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_CCI_3_Credit_Card_Balancing_Payment]
AS
SELECT     CCT.Credit_Card_Type, CCT.Electronic_Authorization, dbo.Location.Location, CCP.Terminal_ID, CCP.Trx_Receipt_Ref_Num AS trn_id, CCP.Authorization_Number, 
                      CC.Credit_Card_Number, CC.Last_Name, CC.First_Name, CC.Expiry, CPI.Contract_Number AS Document_Number, 'Contrat_Credit' AS Document_Type, CPI.Amount, 
                      CPI.Collected_On, CPI.Collected_By, CPI.RBR_Date
FROM         dbo.Contract_Payment_Item AS CPI INNER JOIN
                      dbo.Credit_Card_Payment AS CCP ON CPI.Contract_Number = CCP.Contract_Number AND CPI.Sequence = CCP.Sequence INNER JOIN
                      dbo.Credit_Card AS CC ON CCP.Credit_Card_Key = CC.Credit_Card_Key INNER JOIN
                      dbo.Credit_Card_Type AS CCT ON CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID INNER JOIN
                      dbo.Location ON CPI.Collected_At_Location_ID = dbo.Location.Location_ID
WHERE     (CPI.Payment_Type = 'Credit Card') AND (CPI.Copied_Payment = 0)
UNION
SELECT     'Debit Card' as credit_card_type, '1' as Electronic_Authorization, Location_3.Location, CP.Terminal_ID, CP.Trx_Receipt_Ref_Num AS trn_id, CP.Authorization_Number, 
                      CP.Identification_Number, '' AS Last_Name, '' AS First_Name, '' AS Expiry, CPI.Contract_Number AS Document_Number, 'Contrat_Debit' AS Document_Type, 
                      CPI.Amount, CPI.Collected_On, CPI.Collected_By, CPI.RBR_Date
FROM         dbo.Contract_Payment_Item AS CPI INNER JOIN
                     dbo.Cash_Payment AS CP ON CPI.Contract_Number = CP.Contract_Number AND CPI.Sequence = CP.Sequence INNER JOIN
                                              (select code,value 
													from lookup_table 
													where (category='Cash Payment Method')
														or (category='Cash Refund Method')) AS DB ON cp.Cash_Payment_Type = DB.Code
--                      dbo.Credit_Card_Transaction AS CC ON CC.Contract_Number = CP.Contract_Number AND CP.Authorization_Number = CC.Authorization_Number INNER JOIN
--                      dbo.Credit_Card_Type AS CCT ON CC.Credit_Card_Type_Id = CCT.Credit_Card_Type_ID 
						INNER JOIN dbo.Location AS Location_3 ON CPI.Collected_At_Location_ID = Location_3.Location_ID
WHERE     (db.Value like 'Debit Card%') AND (CPI.Copied_Payment = 0)
UNION
SELECT     CCT.Credit_Card_Type, CCT.Electronic_Authorization, Location_2.Location, rcdp.Terminal_ID, rcdp.Trx_Receipt_Ref_Num AS trn_id, rcdp.Authorization_Number, 
                      CC.Credit_Card_Number, CC.Last_Name, CC.First_Name, CC.Expiry, rdp.Confirmation_Number AS Document_number, 'Reservation' AS Document_Type, rdp.Amount, 
                      rdp.Collected_On, rdp.Collected_By, rdp.RBR_Date
FROM         dbo.Reservation_Dep_Payment AS rdp INNER JOIN
                      dbo.Reservation_CC_Dep_Payment AS rcdp ON rdp.Confirmation_Number = rcdp.Confirmation_Number
						 AND rdp.Collected_On = rcdp.Collected_On   and rdp.sequence=rcdp.sequence INNER JOIN
                      dbo.Credit_Card AS CC ON rcdp.Credit_Card_Key = CC.Credit_Card_Key INNER JOIN
                      dbo.Credit_Card_Type AS CCT ON CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID INNER JOIN
                      dbo.Location AS Location_2 ON rdp.Collected_At_Location_ID = Location_2.Location_ID
WHERE     (rdp.Payment_Type = 'Credit Card')
UNION
SELECT    'Debit Card' as Credit_Card_Type, '1' as Electronic_Authorization, Location_2.Location, rcdp.Terminal_ID, rcdp.Trx_Receipt_Ref_Num AS trn_id, rcdp.Authorization_Number, 
                      rcdp.Identification_Number, '' as Last_Name, '' as First_Name,'' as Expiry, rdp.Confirmation_Number AS Document_number, 'Reservation' AS Document_Type, rdp.Amount, 
                      rdp.Collected_On, rdp.Collected_By, rdp.RBR_Date
FROM         dbo.Reservation_Dep_Payment AS rdp INNER JOIN
                      dbo.Reservation_Cash_Dep_Payment AS rcdp ON rdp.Confirmation_Number = rcdp.Confirmation_Number AND rdp.Collected_On = rcdp.Collected_On inner join
						(select code,value 
							from lookup_table 
							where (category='Cash Payment Method')
								or (category='Cash Refund Method')) AS DB ON rcdp.Cash_Payment_Type = DB.Code
-- INNER JOIN dbo.Credit_Card_Transaction AS CC ON CC.Confirmation_Number = rcdp.Confirmation_Number AND rcdp.Authorization_Number = CC.Authorization_Number  INNER JOIN
--                      dbo.Credit_Card_Type AS CCT ON CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID 
					INNER JOIN  dbo.Location AS Location_2 ON rdp.Collected_At_Location_ID = Location_2.Location_ID
WHERE      (db.value like 'Debit Card%')
UNION
SELECT     sas_payment.Credit_Card_Type, sas_payment.Electronic_Authorization, LocationTerminals.Location, sas_payment.Terminal_ID, sas_payment.trn_id, 
                      sas_payment.Authorization_Number, sas_payment.Credit_Card_Number, sas_payment.Last_Name, sas_payment.First_Name, sas_payment.Expiry, 
                      sas_payment.Document_number, 'Sales ACC' AS Document_Type, sas_payment.Amount, sas_payment.Collected_On, sas_payment.Collected_By, 
                      sas_payment.RBR_Date
FROM         (SELECT     CCT.Credit_Card_Type, CCT.Electronic_Authorization, sacp.Terminal_ID, sacp.Trx_Receipt_Ref_Num AS trn_id, sacp.Authorization_Number, 
                                              CC.Credit_Card_Number, CC.Last_Name, CC.First_Name, CC.Expiry, sasp.Sales_Contract_Number AS Document_number, 
                                              'Sales ACC' AS Document_Type, sasp.Amount, sasp.Collected_On, 'Sales ACC' AS Collected_By, sasp.RBR_Date
                       FROM          dbo.Sales_Accessory_Sale_Payment AS sasp INNER JOIN
                                              dbo.Sales_Accessory_CrCard_Payment AS sacp ON sasp.Sales_Contract_Number = sacp.Sales_Contract_Number INNER JOIN
                                              dbo.Credit_Card AS CC ON sacp.Credit_Card_Key = CC.Credit_Card_Key INNER JOIN
                                              dbo.Credit_Card_Type AS CCT ON CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
                       WHERE      (sasp.Payment_Type = 'Credit Card')) AS sas_payment LEFT OUTER JOIN
                          (SELECT     Location_1.Location, dbo.Terminal.Terminal_ID
                            FROM          dbo.Terminal INNER JOIN
                                                   dbo.Location AS Location_1 ON dbo.Terminal.Location_ID = Location_1.Location_ID) AS LocationTerminals ON 
                      sas_payment.Terminal_ID = LocationTerminals.Terminal_ID
UNION
SELECT     sas_payment.Credit_Card_Type, sas_payment.Electronic_Authorization, LocationTerminals.Location, sas_payment.Terminal_ID, sas_payment.trn_id, 
                      sas_payment.Authorization_Number, sas_payment.Credit_Card_Number, sas_payment.Last_Name, sas_payment.First_Name, sas_payment.Expiry, 
                      sas_payment.Document_number, 'Sales ACC DB' AS Document_Type, sas_payment.Amount, sas_payment.Collected_On, sas_payment.Collected_By, 
                      sas_payment.RBR_Date
FROM         (SELECT     'Debit Card' as Credit_Card_Type, '1' as Electronic_Authorization, sacp.Terminal_ID, sacp.Trx_Receipt_Ref_Num AS trn_id, sacp.Authorization_Number, 
                                              sacp.Identification_Number as Credit_Card_Number, '' AS Last_Name, '' AS First_Name, '' AS Expiry, sasp.Sales_Contract_Number AS Document_number, 
                                              'Sales ACC DB' AS Document_Type, sasp.Amount, sasp.Collected_On, 'Sales ACC DB' AS Collected_By, sasp.RBR_Date
                      FROM          dbo.Sales_Accessory_Sale_Payment AS sasp INNER JOIN
                                              dbo.   Sales_Accessory_Cash_Payment AS sacp ON sasp.Sales_Contract_Number = sacp.Sales_Contract_Number INNER JOIN
                                              (select code,value 
													from lookup_table 
													where (category='Cash Payment Method')
														or (category='Cash Refund Method')) AS DB ON sacp.Cash_Payment_Type = DB.Code
--												INNER JOIN  dbo.Credit_Card_Type AS CCT ON CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
                       WHERE      (DB.Value like 'Debit Card%')) AS sas_payment LEFT OUTER JOIN
                          (SELECT     Location_1.Location, dbo.Terminal.Terminal_ID
                            FROM          dbo.Terminal INNER JOIN
                                                   dbo.Location AS Location_1 ON dbo.Terminal.Location_ID = Location_1.Location_ID) AS LocationTerminals ON 
                      sas_payment.Terminal_ID = LocationTerminals.Terminal_ID
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 5
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_CCI_3_Credit_Card_Balancing_Payment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RP_CCI_3_Credit_Card_Balancing_Payment'
GO
