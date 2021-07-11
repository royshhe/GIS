USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExpediaMonthlyReport]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
PROCEDURE NAME: ExpediaMonthlyReport 
PURPOSE: To generate an expedia monthly Adhoc report
AUTHOR: Kenneth Wong
DATE CREATED: June 15, 2005 

*/


--select * from dbo.Contract_Charge_Item
CREATE PROCEDURE [dbo].[ExpediaMonthlyReport]-- '2011/12/01', '2011/12/30'
	@DateFrom varchar(30)='Jan 01 2004',
	@DateTo varchar(30)='Jan 31, 2004'
AS
DECLARE @StartDate datetime, @EndDate datetime,@VoucherEffectiveDate datetime
SELECT @StartDate = CONVERT(DATETIME, @DateFrom)
SELECT @EndDate = CONVERT(DATETIME, @DateTo)

SELECT @EndDate = CONVERT(DATETIME, @DateTo)
SELECT @EndDate=DATEADD(day, 1, @EndDate) 

select @VoucherEffectiveDate=convert(datetime,'27 apr 2011')

--include before Voucher implement using Direct bill data
SELECT     dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Contract.Pick_Up_On AS Pick_up_date, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In AS Return_date, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name AS Res_Veh_Class_Name, SUM(dbo.Contract_Charge_Item.Amount) AS Amount, dbo.Contract_Billing_Party.Billing_Method As Billing_Method --,dbo.Reservation.BCD_number
						, dbo.location.location as Pick_Up_Location,DOLoc.location as Drop_Off_Location
FROM         dbo.Reservation INNER JOIN
                      dbo.Contract ON dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number INNER JOIN
                      dbo.Contract_Billing_Party ON dbo.Contract.Contract_Number = dbo.Contract_Billing_Party.Contract_Number INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract_Billing_Party.Contract_Number = dbo.Contract_Charge_Item.Contract_Number AND 
                      dbo.Contract_Billing_Party.Contract_Billing_Party_ID = dbo.Contract_Charge_Item.Contract_Billing_Party_ID INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Location DOLoc ON dbo.Contract.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number LEFT OUTER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number LEFT OUTER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Business_Transaction.RBR_Date >= @StartDate) AND (dbo.Business_Transaction.RBR_Date < @EndDate) AND 
                      (dbo.Contract_Billing_Party.Customer_Code = 'EXPEDIA' or dbo.Reservation.BCD_Number='A411700' ) AND (dbo.Contract.Status = 'CI') AND 
                      (dbo.Business_Transaction.Transaction_Description = 'Check in') AND (dbo.Business_Transaction.Transaction_Type = 'con') AND 
                      (dbo.Contract.Status NOT IN ('vd', 'ca'))and dbo.Contract_Charge_Item.Charge_type in (10, 11, 50, 51, 52)
					and dbo.Contract.Pick_Up_On<@VoucherEffectiveDate
GROUP BY dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Contract_Billing_Party.Billing_Method --,dbo.Reservation.BCD_number
						, dbo.location.location,DOLoc.location

--include after Voucher implement using prepayment data
union
SELECT     dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
				  dbo.Contract.Pick_Up_On AS Pick_up_date, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In AS Return_date, dbo.Location.Mnemonic_Code, 
				  dbo.Vehicle_Class.Vehicle_Class_Name AS Res_Veh_Class_Name, SUM(dbo.Prepayment.Foreign_Currency_Amt_Collected) AS Amount, dbo.Prepayment.Payment_Type As Billing_Method --,dbo.Reservation.BCD_number
						, dbo.location.location as Pick_Up_Location,DOLoc.location as Drop_Off_Location
FROM         dbo.Reservation INNER JOIN
				  dbo.Contract ON dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number INNER JOIN
				  dbo.Prepayment ON dbo.Contract.Contract_Number = dbo.Prepayment.Contract_Number  INNER JOIN
				  dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Location DOLoc ON dbo.Contract.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
				  dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number LEFT OUTER JOIN
				  dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number LEFT OUTER JOIN
				  dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Business_Transaction.RBR_Date >= @StartDate) AND (dbo.Business_Transaction.RBR_Date < @EndDate) AND 
				  (dbo.Prepayment.Issuer_ID = 'EXPEDIA' or dbo.Reservation.BCD_Number='A411700' ) AND (dbo.Contract.Status = 'CI') AND 
				  (dbo.Business_Transaction.Transaction_Description = 'Check in') AND (dbo.Business_Transaction.Transaction_Type = 'con') AND 
				  (dbo.Contract.Status NOT IN ('vd', 'ca'))--and dbo.Contract_Charge_Item.Charge_type in (10, 11, 50, 51, 52)
				and dbo.Contract.Pick_Up_On>=@VoucherEffectiveDate
GROUP BY dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
				  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, dbo.Location.Mnemonic_Code, 
				  dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Prepayment.Payment_Type --,dbo.Reservation.BCD_number
						, dbo.location.location,DOLoc.location

--include after Voucher implement using Direct bill data
union
SELECT     dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Contract.Pick_Up_On AS Pick_up_date, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In AS Return_date, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name AS Res_Veh_Class_Name, SUM(dbo.Contract_Charge_Item.Amount) AS Amount, dbo.Contract_Billing_Party.Billing_Method As Billing_Method --,dbo.Reservation.BCD_number
						, dbo.location.location as Pick_Up_Location,DOLoc.location as Drop_Off_Location
FROM         dbo.Reservation INNER JOIN
                      dbo.Contract ON dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number INNER JOIN
                      dbo.Contract_Billing_Party ON dbo.Contract.Contract_Number = dbo.Contract_Billing_Party.Contract_Number INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract_Billing_Party.Contract_Number = dbo.Contract_Charge_Item.Contract_Number AND 
                      dbo.Contract_Billing_Party.Contract_Billing_Party_ID = dbo.Contract_Charge_Item.Contract_Billing_Party_ID INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                       dbo.Location DOLoc ON dbo.Contract.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
                     dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number LEFT OUTER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number LEFT OUTER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Business_Transaction.RBR_Date >= @StartDate) AND (dbo.Business_Transaction.RBR_Date < @EndDate) AND 
                      (dbo.Contract_Billing_Party.Customer_Code = 'EXPEDIA'  ) AND (dbo.Contract.Status = 'CI') AND 
                      (dbo.Business_Transaction.Transaction_Description = 'Check in') AND (dbo.Business_Transaction.Transaction_Type = 'con') AND 
                      (dbo.Contract.Status NOT IN ('vd', 'ca'))and dbo.Contract_Charge_Item.Charge_type in (10, 11, 50, 51, 52)
				and dbo.Contract.Pick_Up_On>=@VoucherEffectiveDate
GROUP BY dbo.Contract.Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Contract_Billing_Party.Billing_Method --,dbo.Reservation.BCD_number
						, dbo.location.location,DOLoc.location


union

SELECT     Null AS Contract_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Last_Name, dbo.Reservation.First_Name, 
                      dbo.Reservation.Pick_Up_On AS Pick_up_date, dbo.Reservation.Drop_Off_On AS Return_date, dbo.Location.Mnemonic_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name AS Res_Veh_Class_Name, NULL AS Amount, '' AS Billing_Method
						, dbo.location.location as Pick_Up_Location,DOLoc.location as Drop_Off_Location
FROM         dbo.Location INNER JOIN
                      dbo.Reservation ON dbo.Location.Location_ID = dbo.Reservation.Pick_Up_Location_ID INNER JOIN
                       dbo.Location DOLoc ON dbo.Reservation.Drop_Off_Location_ID = DOLoc.Location_ID INNER JOIN
                     dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Reservation.BCD_Number='A411700' ) and (dbo.Reservation.status='N') and
  (dbo.Reservation.Pick_Up_On >= @StartDate) AND (dbo.Reservation.Pick_Up_On < @EndDate)



GO
