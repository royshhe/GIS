USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_Detail_for_AirMile_RateCode_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Revenue_Detail_for_AirMile_RateCode_vw]
AS
SELECT     bt.RBR_Date, 
			bt.Contract_Number, 
			c.Confirmation_Number,
			 c.First_Name, 
			c.Last_Name,-- c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, 
            PULoc.Location AS PU_Location, 
			DOLoc.Location AS DO_Location, 
			veh.Owning_Company_ID, 
			c.Company_Name,
            (CASE WHEN c.BCD_Rate_Organization_id IS NOT NULL 
                      THEN BCD_Rate_Organization.Organization 
                  WHEN res.BCD_number IS NOT NULL THEN res.Organization ELSE NULL END) AS Organization_Name, 
			PULoc.Owning_Company_ID AS PULoc_OID, 
            DOLoc.Owning_Company_ID AS DOLoc_OID, 
			vc.Vehicle_Type_ID, 
			vc.Vehicle_Class_Name,
			vmy.Model_Name, vmy.Model_Year, 
			c.Pick_Up_On,  
            DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In) / 1440.0 AS Contract_Rental_Days, 
			ckd.KmDriven, 
                      CASE WHEN (c.Confirmation_Number IS NOT NULL OR
                      c.Foreign_Contract_Number IS NOT NULL) THEN 0 ELSE 1 END AS Walk_Up, 
			CASE WHEN vr.rate_name IS NOT NULL THEN vr.rate_name ELSE dbo.Quoted_Vehicle_Rate.Rate_Name END AS Rate_Name,
			VR.Rate_Purpose_ID,
			o.Org_Type, 
                      (CASE WHEN c.BCD_Rate_Organization_id IS NOT NULL 
                      THEN BCD_Rate_Organization.BCD_number WHEN res.BCD_number IS NOT NULL THEN res.BCD_number ELSE NULL END) AS BCD_number,
				CRS.TimeCharge, 
				crs.Upgrade,
				crs.KMCharge, 
				DropOff_Charge,
				FPO,
				Additional_Driver_Charge,
				All_Seats,
				Driver_Under_Age,
				All_Level_LDW,
				PAI,
				PEC,
				Ski_Rack,
				All_Dolly,
				All_Gates,
				Blanket
                      --c.Reservation_Revenue, cci.Amount - cci.GST_Amount_Included - cci.PST_Amount_Included - cci.PVRT_Amount_Included AS Amount, 


                      --OE.TYPE
FROM         dbo.Contract AS c WITH (NOLOCK) INNER JOIN
                      dbo.Location AS PULoc ON c.Pick_Up_Location_ID = PULoc.Location_ID INNER JOIN
                      dbo.Location AS DOLoc ON c.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
                      dbo.Business_Transaction AS bt ON bt.Contract_Number = c.Contract_Number INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract AS rlv ON c.Contract_Number = rlv.Contract_Number INNER JOIN
                      dbo.Vehicle AS veh ON rlv.Unit_Number = veh.Unit_Number INNER JOIN
                      dbo.Vehicle_Model_Year AS vmy ON veh.Vehicle_Model_ID = vmy.Vehicle_Model_ID INNER JOIN
                      dbo.Contract_KmDriven_vw AS ckd ON c.Contract_Number = ckd.Contract_Number LEFT OUTER JOIN
                      dbo.Contract_Revenue_Sum_vw AS CRS ON c.Contract_Number = CRS.Contract_Number LEFT OUTER JOIN
                      --dbo.Optional_extra as OE on cci.Optional_Extra_ID=oe.Optional_Extra_ID LEFT OUTER JOIN
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
                      
WHERE     (	 vr.Rate_Name in ('ZBI/15/L',
								'ZBI/15/L2',
								'ZBI/15/M',
								'ZBI/15/H',
								'ZCI/15/L',
								'ZCI/15/L2',
								'ZCI/15/M',
								'ZCI/15/LH',

								'ZBI/14/L',
								'ZBI/14/L2',
								'ZBI/14/H',
								'ZCI/14/L',
								'ZCI/14/L2',
								'ZCI/14/H',

								'A6I/14/L',
								'A6I/14/H',
								'A6I/15/L',
								'A6I/15/H'

								)
				 ) 
                    
                    AND (bt.Transaction_Type = 'con') 
                    AND (bt.Transaction_Description IN ('check in', 'foreign check in')) 
                    AND (c.Status = 'CI')
GO
