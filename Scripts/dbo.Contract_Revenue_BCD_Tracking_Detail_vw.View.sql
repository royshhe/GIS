USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_BCD_Tracking_Detail_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Contract_Revenue_BCD_Tracking_Detail_vw]
AS
SELECT     bt.RBR_Date, bt.Contract_Number, c.Confirmation_Number, c.First_Name, c.Last_Name, c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, 
                      PULoc.Location AS PU_Location, DOLoc.Location AS DO_Location, veh.Owning_Company_ID, PULoc.Owning_Company_ID AS PULoc_OID, 
                      DOLoc.Owning_Company_ID AS DOLoc_OID, c.Pick_Up_On, vc.Vehicle_Type_ID, vc.Vehicle_Class_Name, vmy.Model_Name, vmy.Model_Year, 
                      DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In) / 1440.0 AS Contract_Rental_Days, ckd.KmDriven, 
                      CASE WHEN (c.Confirmation_Number IS NOT NULL OR
                      c.Foreign_Contract_Number IS NOT NULL) THEN 0 ELSE 1 END AS Walk_Up, cci.Charge_Type, cci.Charge_Item_Type, cci.Optional_Extra_ID, 					  
					  Optional_Extra.Type as OptionalExtraType,
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
                      dbo.Contract_KmDriven_vw AS ckd ON c.Contract_Number = ckd.Contract_Number INNER JOIN
                      dbo.Contract_Charge_Item AS cci ON c.Contract_Number = cci.Contract_Number INNER JOIN
                      dbo.Vehicle_Class AS vc ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code 
					LEFT JOIN
	               dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID and dbo.Optional_Extra.Delete_flag=0
                  LEFT OUTER JOIN
                      dbo.Vehicle_Rate AS vr ON c.Rate_ID = vr.Rate_ID AND c.Rate_Assigned_Date BETWEEN vr.Effective_Date AND 
                      vr.Termination_Date LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON c.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Organization AS o ON o.Organization_ID = c.Referring_Organization_ID LEFT OUTER JOIN
                      dbo.Organization AS BCD_Rate_Organization ON BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_ID LEFT OUTER JOIN
                          (SELECT     dbo.Reservation.Confirmation_Number, dbo.Organization.BCD_Number, dbo.Organization.Organization
                            FROM          dbo.Reservation LEFT OUTER JOIN
                                                   dbo.Organization ON dbo.Reservation.BCD_Number = dbo.Organization.BCD_Number) AS Res ON 
                      c.Confirmation_Number = Res.Confirmation_Number
WHERE   
--           (  
--                    (  c.BCD_Rate_Organization_ID IN
--                          (SELECT     Organization_ID
--                            FROM          dbo.Organization AS Organization_4
--                            WHERE      ((Organization LIKE  '%FED%Gov' ) or BCD_Number IN ('A044300', 'Y069300') )
--                          ) 
--					)	
--                     OR
                     
--                    (  Res.Organization LIKE 'FED%Gov') OR
--					(  Res.BCD_Number IN ('A044300', 'Y069300') )
--              )
--              And
			 (  
							(bt.Transaction_Type = 'con') 
				 AND (bt.Transaction_Description IN ('check in') )
				 AND (c.Status = 'CI')
                )

GO
