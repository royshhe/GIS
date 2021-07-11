USE [GISData]
GO
/****** Object:  View [dbo].[tmpSkyTour]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpSkyTour]
AS
SELECT         bt.RBR_Date, bt.Contract_Number, c.pick_up_location_id AS Pick_Up_Location_ID,c.Pick_Up_On, vc.Vehicle_Type_ID, vc.Vehicle_Class_Name, vmy.model_name, 
                      vmy.model_year, DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In) / 1440.0 AS Contract_Rental_Days, rlv.km_in - rlv.km_out AS KmDriven, 
                      Walk_Up = CASE WHEN (c.Confirmation_Number IS NOT NULL OR
                      c.Foreign_Contract_Number IS NOT NULL) THEN 0 ELSE 1 END, cci.Charge_Type, cci.Charge_item_type, cci.Optional_Extra_ID,Optional_Extra.Type as OptionalExtraType, 
                      c.Reservation_Revenue, Amount = cci.Amount - cci.GST_Amount_Included - cci.PST_Amount_Included - cci.PVRT_Amount_Included, vr.rate_name, 
                      (case 
		when cp.Customer_Code is null then
		          C.Company_Name
                           else
                               cp.Customer_Code 
                       end) as customer,
                      vr.Rate_Purpose_ID, o.Org_Type
FROM         Contract c WITH (NOLOCK) INNER JOIN
                      Contract_Billing_Party cp ON cp.contract_number = c.contract_number INNER JOIN
                      Business_Transaction bt ON bt.Contract_Number = c.Contract_Number INNER JOIN
                      RP__Last_Vehicle_On_Contract rlv ON c.Contract_Number = rlv.Contract_Number INNER JOIN
                      Vehicle veh ON rlv.unit_number = veh.unit_number INNER JOIN
                      vehicle_model_year vmy ON veh.vehicle_model_id = vmy.vehicle_model_id LEFT JOIN
                      Contract_Charge_Item cci ON c.Contract_Number = cci.Contract_Number LEFT JOIN
                      Vehicle_Class vc ON veh.Vehicle_Class_Code = vc.Vehicle_Class_Code INNER JOIN
                      location l ON c.pick_up_location_id = l.location_id LEFT JOIN
                      Vehicle_Rate vr ON c.rate_id = vr.rate_id AND c.Rate_Assigned_Date BETWEEN vr.Effective_Date AND vr.Termination_Date LEFT JOIN
                      organization o ON o.Organization_ID = c.Referring_Organization_ID
                     LEFT JOIN
	       dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID and dbo.Optional_Extra.Delete_flag=0
WHERE     (bt.Transaction_Type = 'con') AND (bt.Transaction_Description IN ('check in', 'foreign check in')) AND c.Status = 'CI' AND 
                      veh.owning_company_id = 7425 AND (cp.Customer_Code = 'SKYTOUR' OR
                      c.BCD_Rate_Organization_ID IN (1014, 1015, 1027, 1028) OR
                      c.Company_Name LIKE '%SKY%TOUR%') AND l.hub_id = 1




GO
