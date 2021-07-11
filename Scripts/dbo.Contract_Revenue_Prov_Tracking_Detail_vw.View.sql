USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_Prov_Tracking_Detail_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Revenue_Prov_Tracking_Detail_vw]
AS
SELECT     bt.RBR_Date, bt.Contract_Number, c.Confirmation_Number, c.First_Name, c.Last_Name, c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, 
                      PULoc.Location AS PU_Location, DOLoc.Location AS DO_Location, veh.Owning_Company_ID, PULoc.Owning_Company_ID AS PULoc_OID, 
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
WHERE     (vr.Rate_Purpose_ID = 22 --AND vr.Rate_Name NOT IN ('FED02', 'FED02A', 'Fed03AP', 'FEd03Local') AND vr.Rate_Name NOT LIKE '%FED%Gov' AND 
--                      vr.Rate_Name NOT LIKE '%FED03%' AND vr.Rate_Name NOT LIKE '%FED04%' AND vr.Rate_Name NOT LIKE '%GOC%' 
						OR
                      c.Company_Name LIKE '%BCIT%' OR
                      c.Company_Name LIKE '%VCC%' OR
                      c.Company_Name LIKE '%Vancouver Community college%' OR
                      c.Company_Name LIKE '%TWU%' OR
                      c.Company_Name LIKE '%Trinity Western university%' OR
                      c.Company_Name LIKE '%SFU%' OR
                      c.Company_Name LIKE '%Simon Fraser university%' OR
                      c.Company_Name LIKE '%Simon Fraser%' OR
                      c.Company_Name LIKE '%UBC%' OR
                      c.Company_Name LIKE '%University of BC%' OR
                      c.Company_Name LIKE '%University of B%C%' OR
                      c.Company_Name LIKE '%UNBC%' OR
                      c.Company_Name LIKE '%Univ. of northern B.C.%' OR
                      c.Company_Name LIKE '%Univ of northern BC%' OR
                      c.Company_Name LIKE '%U%of nor%BC%' OR
                      c.Company_Name LIKE '%Uvic%' OR
                      c.Company_Name LIKE '%Univ% of %Vic%' OR
                      c.Company_Name LIKE '%University of Vic%' OR
                      c.Company_Name LIKE '%University of Victoria%' OR
                      c.Company_Name LIKE '%Douglas college%' OR
                      c.Company_Name LIKE '%Kwantlen%' OR
                      c.Company_Name LIKE '%Camosun college%' OR
                      c.Company_Name LIKE '%Okanagan u%' OR
                      c.Company_Name LIKE '%Okanagan university college%' OR
                      c.Company_Name LIKE '%Okanagan college%' OR
                      c.Company_Name LIKE 'O% univ coll%' OR
                      c.Company_Name LIKE '%Open learning agency%' OR
                      c.Company_Name LIKE '%BC%Hydro%' OR
                      c.Company_Name LIKE '%BC%prov%' OR
                      c.Company_Name LIKE 'Prov%BC%' OR
                      c.Company_Name LIKE 'BC%Gov%' OR
                      c.Company_Name LIKE '%BC%Rail%' OR
                      c.BCD_Rate_Organization_ID IN
                          (SELECT     Organization_ID
                            FROM          dbo.Organization AS Organization_4
                            WHERE      (Organization LIKE 'BC%hy%')) OR
                      c.BCD_Rate_Organization_ID IN
                          (SELECT     Organization_ID
                            FROM          dbo.Organization AS Organization_3
                            WHERE      (Organization LIKE 'BC%Ra%')) OR
                      c.BCD_Rate_Organization_ID IN
                          (SELECT     Organization_ID
                            FROM          dbo.Organization AS Organization_2
                            WHERE      (Organization LIKE 'BC%Gov%')) OR
                      c.BCD_Rate_Organization_ID IN
                          (SELECT     Organization_ID
                            FROM          dbo.Organization AS Organization_1
                            WHERE      (Organization LIKE '%BC%prov%')) OR
                      dbo.Quoted_Vehicle_Rate.Rate_Purpose_ID = 5 AND dbo.Quoted_Vehicle_Rate.Rate_Name = '01i' OR
                      Res.Organization LIKE 'BC%hy%' OR
                      Res.Organization LIKE 'BC%Ra%' OR
                      Res.Organization LIKE 'BC%Gov%' OR
                      Res.Organization LIKE '%BC%prov%' OR
                      Res.BCD_Number IN ('A162000', 'A294500', 'A171000', 'a367200', 'A162050')) AND (bt.Transaction_Type = 'con') AND 
                      (bt.Transaction_Description IN ('check in', 'foreign check in')) AND (c.Status = 'CI')
GO
