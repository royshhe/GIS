USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_Goverment_Tracking_Detail_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Contract_Revenue_Goverment_Tracking_Detail_vw]
AS
SELECT     bt.RBR_Date, bt.Contract_Number, c.Confirmation_Number, c.First_Name, c.Last_Name, c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, 
                      PULoc.Location AS PU_Location,puloc.LocationName as LocationName, DOLoc.Location AS DO_Location, veh.Owning_Company_ID, PULoc.Owning_Company_ID AS PULoc_OID, 
                      DOLoc.Owning_Company_ID AS DOLoc_OID, c.Pick_Up_On, vc.Vehicle_Type_ID, vc.Vehicle_Class_Name, vmy.Model_Name, vmy.Model_Year, 
                      DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In) / 1440.0 AS Contract_Rental_Days, ckd.KmDriven, 
                      CASE WHEN (c.Confirmation_Number IS NOT NULL OR
                      c.Foreign_Contract_Number IS NOT NULL) THEN 0 ELSE 1 END AS Walk_Up, cci.Charge_Type, cci.Charge_Item_Type, cci.Optional_Extra_ID, 
                      c.Reservation_Revenue, cci.Amount - cci.GST_Amount_Included - cci.PST_Amount_Included - cci.PVRT_Amount_Included AS Amount, 
                      CASE WHEN vr.rate_name IS NOT NULL THEN vr.rate_name ELSE dbo.Quoted_Vehicle_Rate.Rate_Name END AS Rate_Name, vr.Rate_Purpose_ID, 
                      c.Company_Name, (CASE WHEN c.BCD_Rate_Organization_id IS NOT NULL 
                      THEN BCD_Rate_Organization.Organization WHEN res.BCD_number IS NOT NULL THEN res.Organization ELSE NULL END) AS Organization_Name, 
                      o.Org_Type, (CASE WHEN c.BCD_Rate_Organization_id IS NOT NULL 
                      THEN BCD_Rate_Organization.BCD_number WHEN res.BCD_number IS NOT NULL THEN res.BCD_number ELSE NULL END) AS BCD_number
FROM         dbo.Contract AS c WITH (NOLOCK) INNER JOIN
                      dbo.Location AS PULoc ON c.Pick_Up_Location_ID = PULoc.Location_ID INNER JOIN
                      dbo.Location AS DOLoc ON c.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
                      dbo.Business_Transaction AS bt ON bt.Contract_Number = c.Contract_Number INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract AS rlv ON c.Contract_Number = rlv.Contract_Number INNER JOIN
                      dbo.Vehicle AS veh ON rlv.Unit_Number = veh.Unit_Number INNER JOIN
                      dbo.Vehicle_Model_Year AS vmy ON veh.Vehicle_Model_ID = vmy.Vehicle_Model_ID INNER JOIN
                      dbo.Contract_KmDriven_vw AS ckd ON c.Contract_Number = ckd.Contract_Number LEFT OUTER JOIN
                      dbo.Contract_Charge_Item AS cci ON c.Contract_Number = cci.Contract_Number LEFT OUTER JOIN
                      dbo.Vehicle_Class AS vc ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code LEFT OUTER JOIN
                      dbo.Vehicle_Rate AS vr ON c.Rate_ID = vr.Rate_ID AND c.Rate_Assigned_Date BETWEEN vr.Effective_Date AND 
                      vr.Termination_Date LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON c.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Organization AS o ON o.Organization_ID = c.Referring_Organization_ID LEFT OUTER JOIN
                      dbo.Organization AS BCD_Rate_Organization ON BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_ID LEFT OUTER JOIN
                          (SELECT     dbo.Reservation.Confirmation_Number, dbo.Organization.BCD_Number, dbo.Organization.Organization
                            FROM          dbo.Reservation LEFT OUTER JOIN
                                                   dbo.Organization ON dbo.Reservation.BCD_Number = dbo.Organization.BCD_Number) AS Res ON 
                      c.Confirmation_Number = Res.Confirmation_Number
WHERE    (vr.Rate_Purpose_ID in (22)-- for Frontend report used
--				AND vr.Rate_Name NOT IN ('FED02', 'FED02A', 'Fed03AP', 'FEd03Local')
--				AND vr.Rate_Name NOT LIKE '%FED%Gov' 
--				AND vr.Rate_Name NOT LIKE '%FED03%' 
--				AND vr.Rate_Name NOT LIKE '%FED04%' 
--				AND vr.Rate_Name NOT LIKE '%GOC%'
			OR  c.Company_Name LIKE '%BCIT%'
			OR  c.Company_Name LIKE '%VCC%' 
			OR  c.Company_Name LIKE '%Vancouver Community college%' 
			OR  c.Company_Name LIKE '%TWU%' 
			OR  c.Company_Name LIKE '%Trinity Western university%' 
			OR  c.Company_Name LIKE '%SFU%' 
			OR  c.Company_Name LIKE '%Simon Fraser university%' 
			OR  c.Company_Name LIKE '%Simon Fraser%' 
			OR  c.Company_Name LIKE '%UBC%' 
			OR  c.Company_Name LIKE '%University of BC%' 
			OR  c.Company_Name LIKE '%University of B%C%' 
			OR  c.Company_Name LIKE '%UNBC%' 
			OR  c.Company_Name LIKE '%Univ. of northern B.C.%' 
			OR  c.Company_Name LIKE '%Univ of northern BC%'
			OR  c.Company_Name LIKE '%U%of nor%BC%' 
			OR  c.Company_Name LIKE '%Uvic%' 
			OR  c.Company_Name LIKE '%Univ% of %Vic%' 
			OR  c.Company_Name LIKE '%University of Vic%' 
			OR  c.Company_Name LIKE '%University of Victoria%' 
			OR  c.Company_Name LIKE '%Douglas college%' 
			OR  c.Company_Name LIKE '%Kwantlen%' 
			OR  c.Company_Name LIKE '%Camosun college%' 
			OR  c.Company_Name LIKE '%Okanagan u%' 
			OR  c.Company_Name LIKE '%Okanagan university college%' 
			OR  c.Company_Name LIKE '%Okanagan college%' 
			OR  c.Company_Name LIKE 'O% univ coll%' 
			OR  c.Company_Name LIKE '%Open learning agency%' 
			OR  c.Company_Name LIKE '%BC%Hydro%' 
			OR  c.Company_Name LIKE '%BC%Rail%' 
			OR  c.Company_Name LIKE '%BC%prov%' 
			OR  c.Company_Name LIKE 'Prov%BC%' 
			OR  c.Company_Name LIKE 'BC%Gov%' 
			OR  c.BCD_Rate_Organization_ID IN
                   	 	(SELECT     Organization_ID
                            FROM          dbo.Organization AS Organization_4
                            WHERE      (Organization LIKE 'BC%hy%')) 
			OR  c.BCD_Rate_Organization_ID IN
                        (SELECT     Organization_ID
                         	FROM          dbo.Organization AS Organization_3
                            WHERE      (Organization LIKE 'BC%Ra%')) 
			OR  c.BCD_Rate_Organization_ID IN
                        (SELECT     Organization_ID
                           	FROM          dbo.Organization AS Organization_2
                           	WHERE      (Organization LIKE 'BC%Gov%')) 
			OR  c.BCD_Rate_Organization_ID IN
                        (SELECT     Organization_ID
                           	FROM          dbo.Organization AS Organization_1
                            WHERE      (Organization LIKE '%BC%prov%')) 
			OR  dbo.Quoted_Vehicle_Rate.Rate_Purpose_ID = 5 AND dbo.Quoted_Vehicle_Rate.Rate_Name = '01i' 
			OR  Res.Organization LIKE 'BC%hy%' 
			OR  Res.Organization LIKE 'BC%Ra%' 
			OR  Res.Organization LIKE 'BC%Gov%' 
			OR  Res.Organization LIKE '%BC%prov%' 
			OR  Res.BCD_Number IN ('A162000',
			'A162090', 
			'A162080','A162050', 
			'A294500',
			'A171000', 
			'a367200',
			'Z871420', 
			'U196910',
			'U203029',
			'Z871420'
			
			  )) AND (bt.Transaction_Type = 'con') AND 
                   (bt.Transaction_Description IN ('check in', 'foreign check in')) AND (c.Status = 'CI')


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[34] 3) )"
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
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PULoc"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DOLoc"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bt"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rlv"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 277
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "veh"
            Begin Extent = 
               Top = 546
               Left = 38
               Bottom = 654
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vmy"
            Begin Extent = 
               Top = 6
               Left = 291
               Bottom = 114
               Right = 469
            End
            DisplayFlags = 280
            TopColumn = 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Revenue_Goverment_Tracking_Detail_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         End
         Begin Table = "ckd"
            Begin Extent = 
               Top = 330
               Left = 276
               Bottom = 408
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cci"
            Begin Extent = 
               Top = 654
               Left = 38
               Bottom = 762
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vc"
            Begin Extent = 
               Top = 762
               Left = 38
               Bottom = 870
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vr"
            Begin Extent = 
               Top = 870
               Left = 38
               Bottom = 978
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Quoted_Vehicle_Rate"
            Begin Extent = 
               Top = 978
               Left = 38
               Bottom = 1086
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 1086
               Left = 38
               Bottom = 1194
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BCD_Rate_Organization"
            Begin Extent = 
               Top = 1194
               Left = 38
               Bottom = 1302
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Res"
            Begin Extent = 
               Top = 1302
               Left = 38
               Bottom = 1395
               Right = 222
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Revenue_Goverment_Tracking_Detail_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Contract_Revenue_Goverment_Tracking_Detail_vw'
GO
