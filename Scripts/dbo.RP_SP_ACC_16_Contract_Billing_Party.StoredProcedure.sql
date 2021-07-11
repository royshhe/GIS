USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_16_Contract_Billing_Party]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[RP_SP_ACC_16_Contract_Billing_Party] --'2006-01-01','2006-04-21' 
(
	@paramStartDate varchar(20) = '22 Apr 2001',
	@paramEndDate varchar(20) = '23 Apr 2001'
)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime


SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '00:00:00 ' + @paramEndDate)+1	

SELECT  dbo.Business_Transaction.rbr_date,dbo.Reservation.BCD_Number,dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, ResDropOffLoc.Location AS DropOffLocatioin, 
	ResPickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
	dbo.Reservation.Last_Name,  dbo.Reservation.Coupon_Code, 
	(case when ResGISRate.Rate_Name is not null then
		ResGISRate.Rate_Name 
	     else        
		ResQuotedRate.Rate_Name
	end)  ResRate, 
	ResQuotedRate.Authorized_DO_Charge AS DropOffCharge, ResChgHist.ResMadeTime, 
	dbo.Reservation.Status, 
	dbo.Vehicle_Class.Vehicle_Class_Name as ResVehicleClass,
        dbo.Contract.Contract_Number,
        (case when ContractGISRate.Rate_Name is not null then
		ContractGISRate.Rate_Name
	      else ContractQuotedRate.Rate_Name
	end) ConRate,

	max(case when dbo.Contract_Billing_Party.Billing_Method='Renter' then
	 dbo.Renter_Primary_Billing.Renter_Authorization_Method
	else ''
	end) as Renter_Billing,
		
	max(case when dbo.Contract_Billing_Party.Billing_Method='Direct Bill'
	then  dbo.Contract_Billing_Party.Customer_Code 	
		else ''
	end) as Direct_Bill_Customer

FROM         dbo.Contract_Billing_Party INNER JOIN
                      dbo.Contract ON dbo.Contract_Billing_Party.Contract_Number = dbo.Contract.Contract_Number INNER JOIN
                      dbo.Organization INNER JOIN
                      dbo.Reservation ON dbo.Organization.BCD_Number = dbo.Reservation.BCD_Number 
		      INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code 		
                      INNER JOIN
                      dbo.RP__Reservation_Make_Time ResChgHist ON dbo.Reservation.Confirmation_Number = ResChgHist.Confirmation_Number INNER JOIN
                      dbo.Location ResDropOffLoc ON dbo.Reservation.Drop_Off_Location_ID = ResDropOffLoc.Location_ID INNER JOIN
                      dbo.Location ResPickupLoc ON dbo.Reservation.Pick_Up_Location_ID = ResPickupLoc.Location_ID ON 
                      dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number 
		      INNER JOIN dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number 
		      
 		      LEFT OUTER JOIN
                      dbo.Renter_Primary_Billing ON dbo.Contract_Billing_Party.Contract_Number = dbo.Renter_Primary_Billing.Contract_Number AND 
                      dbo.Contract_Billing_Party.Contract_Billing_Party_ID = dbo.Renter_Primary_Billing.Contract_Billing_Party_ID LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ContractQuotedRate ON dbo.Contract.Quoted_Rate_ID = ContractQuotedRate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ResQuotedRate ON dbo.Reservation.Quoted_Rate_ID = ResQuotedRate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Vehicle_Rate ResGISRate ON (ResGISRate.Rate_ID = dbo.Reservation.Rate_ID AND dbo.Reservation.Date_Rate_Assigned BETWEEN ResGISRate.Effective_Date AND 
                      ResGISRate.Termination_Date) LEFT OUTER JOIN
                      dbo.Vehicle_Rate ContractGISRate ON (ContractGISRate.Rate_ID = dbo.Contract.Rate_ID  AND dbo.Contract.Rate_Assigned_Date BETWEEN 
                      ContractGISRate.Effective_Date AND ContractGISRate.Termination_Date) 
WHERE     --(dbo.Reservation.Status = 'A' OR dbo.Reservation.Status = 'O') AND 
        (dbo.Organization.Tour_Rate_Account = 1) --and dbo.Reservation.BCD_number='A535600'
	AND (dbo.Business_Transaction.Transaction_Type = 'con') 
     	AND (dbo.Business_Transaction.Transaction_Description = 'check in') 
    	AND  dbo.Contract .Status not in ('vd', 'ca') and dbo.Business_Transaction.rbr_date>=@startDate and dbo.Business_Transaction.rbr_date<@endDate
group by
dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, ResDropOffLoc.Location,
	ResPickupLoc.Location, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
	dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, ResQuotedRate.Rate_Name, 
	ResGISRate.Rate_Name, ResQuotedRate.Authorized_DO_Charge, ResChgHist.ResMadeTime, 
	dbo.Reservation.Status, dbo.Contract.Contract_Number, ContractGISRate.Rate_Name, 
	ContractQuotedRate.Rate_Name,dbo.Business_Transaction.RBR_Date,dbo.Vehicle_Class.Vehicle_Class_Name
order by dbo.Reservation.BCD_Number,dbo.Business_Transaction.rbr_date




GO
