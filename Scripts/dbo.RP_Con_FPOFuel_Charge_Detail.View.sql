USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_FPOFuel_Charge_Detail]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create VIEW [dbo].[RP_Con_FPOFuel_Charge_Detail]
AS
SELECT      bt.RBR_Date, 
					c.Contract_Number, 
					c.Foreign_Contract_Number, 
					c.Pick_Up_Location_ID, 
					c.Drop_Off_Location_ID, 
					c.Pick_Up_On, 
					rlv.Actual_Drop_Off_Location_ID, 
                    vc.Vehicle_Type_ID, 
					rlv.Unit_Number, 
					rlv.Actual_Check_In, rlv.Km_In, 
					rlv.Km_In - rlv.Km_Out AS Km_Driven, 
					v.Foreign_Vehicle_Unit_Number, 
                    cci.Charge_Type, 
					cci.Optional_Extra_ID, 
					cci.Unit_Amount, 
					cci.Unit_Type,
					cci.Quantity,
					cci.Amount, 
					NetAmount = cci.Amount 	- cci.GST_Amount_Included
																- cci.PST_Amount_Included 
																- cci.PVRT_Amount_Included,

					 cci.GST_Amount_Included AS GST, 
					 cci.PST_Amount_Included AS PST, 
                     cci.PVRT_Amount_Included AS PVRT
FROM         dbo.Contract c INNER JOIN
                      dbo.Contract_Charge_Item cci ON c.Contract_Number = cci.Contract_Number INNER JOIN
                      dbo.Vehicle_Class vc ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract rlv ON c.Contract_Number = rlv.Contract_Number INNER JOIN
                      dbo.Vehicle v ON v.Unit_Number = rlv.Unit_Number INNER JOIN
                      dbo.Business_Transaction bt ON c.Contract_Number = bt.Contract_Number
WHERE     (c.Status NOT IN ('vd', 'ca')) AND (bt.Transaction_Type = 'con') AND (bt.Transaction_Description  in  ('check in', 'Foreign Check In'))
				and  cci.Charge_Type in (14,18)


GO
