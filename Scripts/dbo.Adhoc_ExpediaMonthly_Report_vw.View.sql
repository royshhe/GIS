USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_ExpediaMonthly_Report_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Adhoc_ExpediaMonthly_Report_vw]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Contract.Pick_Up_On AS Pick_up_date, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In AS Return_date, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name AS Res_Veh_Class_Name, SUM(dbo.Contract_Charge_Item.Amount) AS Amount
FROM         dbo.Reservation INNER JOIN
                      dbo.Contract ON dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number INNER JOIN
                      dbo.Contract_Billing_Party ON dbo.Contract.Contract_Number = dbo.Contract_Billing_Party.Contract_Number INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract_Billing_Party.Contract_Number = dbo.Contract_Charge_Item.Contract_Number AND 
                      dbo.Contract_Billing_Party.Contract_Billing_Party_ID = dbo.Contract_Charge_Item.Contract_Billing_Party_ID INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number LEFT OUTER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number LEFT OUTER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Business_Transaction.RBR_Date >= '2005-04-01') AND (dbo.Business_Transaction.RBR_Date < '2005-05-01') AND 
                      (dbo.Contract_Billing_Party.Customer_Code = 'EXPEDIA') AND (dbo.Contract.Status = 'CI') AND 
                      (dbo.Business_Transaction.Transaction_Description = 'Check in') AND (dbo.Business_Transaction.Transaction_Type = 'con') AND 
                      (dbo.Contract.Status NOT IN ('vd', 'ca'))
GROUP BY dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name
GO
