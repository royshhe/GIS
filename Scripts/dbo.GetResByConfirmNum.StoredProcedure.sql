USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResByConfirmNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetResByConfirmNum    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResByConfirmNum    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetResByConfirmNum] --'2535055' -- 2534131 I782534131VAN
	@ConfirmNum Varchar(20)
AS
	/* 981029 - cpy - removed Rate_Selection_Date from Reservation
                        - keep "" after Rate_Id as a placeholder */
	/* 990112 - cpy - renamed phone number columns */
	-- Don K - Aug 11 1999 - Added org name
	/* 9/30/99 - do type conversion outside of select */
	/* 10/18/99 - return email address */

DECLARE @iConfirmNum Int
DECLARE @BookedDate Varchar(20)


	SELECT	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum, ''))

	SELECT     @BookedDate=	Convert(Varchar(20), MIN(Changed_On), 113)
	FROM         dbo.Reservation_Change_History
	Where Confirmation_Number=@iConfirmNum
	--GROUP BY Confirmation_Number

	SELECT	resv.Confirmation_Number,
		resv.Foreign_Confirm_Number,
		resv.Program_Number,
		resv.Pick_Up_Location_ID, 			-- PUL
		Convert(Varchar(11), resv.Pick_Up_On, 13),	-- PUD
		Convert(Varchar(5), resv.Pick_Up_On,  114), 	-- PUT
		Convert(Varchar(11), resv.Drop_Off_On, 13), 	-- DOD
		Convert(Varchar(5), resv.Drop_Off_On, 114),	-- DOT
		resv.Drop_Off_Location_ID, 			-- DOL
		resv.Vehicle_Class_Code,--10
		resv.Flight_Number,		
		Convert(Char(1), resv.Smoking_Non_Smoking),
		resv.Customer_Id,
		resv.Last_Name,
		resv.First_Name,
		resv.Contact_Phone_Number, 		-- previously NA_Phone_Number
		resv.Business_Phone_Number, 		-- previously INT_Phone_Number
		resv.Fax_Number,
		Convert(Char(1), resv.Fax_Confirmation),
		resv.Payment_Method,	--20
		resv.Credit_Card_Type_ID,		
		Convert(Char(1), resv.Deposit_Waived),
		resv.Deposit_Method,
		resv.BCD_Rate_Org_Id,
		resv.Affiliated_BCD_Org_Id,
		resv.Referring_Org_Id,
		resv.Referring_Employee_Id,
		resv.IATA_Number,
		resv.Rate_ID,
		'', 	-- Convert(Varchar(24), Rate_Selection_Date, 113),	--30
		Convert(Varchar(20), resv.Date_Rate_Assigned,  113),	
		resv.Rate_Level,
		resv.Discount_ID,
		resv.Flex_Discount,
		resv.Special_Comments,
		resv.Last_Changed_By,
		Convert(Varchar(20), resv.Last_Changed_On, 113),
		Convert(Char(1), resv.Maestro_Guarantee) Maestro_Guarantee,
		Convert(Char(1), resv.Copied),
		resv.Status,		--40
		resv.Cancellation_Reason,		
		resv.Marketing_Source_Id,
		resv.Source_Code,
		Convert(Char(1), resv.PrePay_Indicator),
		Convert(Char(1), resv.Fastbreak_Indicator),
		Convert(Char(1), resv.Executive_Action_Indicator),
		Convert(Char(1), resv.Applicant_Status_Indicator),
		Convert(Char(1), resv.Perfect_Drive_Indicator),
		Convert(Char(1), resv.Guaranteed_Rate_Indicator),
		resv.Company_Name,		--50
		OrgBCDRate.BCD_Number RateBCDNumber,   -- BCDNum ??	
		resv.Guarantee_Credit_Card_Key,
		resv.Quoted_Rate_Id,
		resv.Guarantee_Deposit_Amount,
		resv.Customer_Code,
		--Convert(char(1), resv.Swiped_Flag) Swiped_Flag,
		(Case When RDP.Amount is not null and RDP.Amount<>0 then '1' Else '0' End) DepositTaken, 		
		'' OverrideTruckAvailCheck, 	-- placeholder for OverrideTruckAvailCheck
		'' Trx_Code,		--for Trx Code
		resv.Email_Address,	
		resv.COupon_Code,	--60
		resv.CID,
		resv.Rate_Code,		
		resv.Res_Booking_City,		
		Truck_Res_Type,		
		'' Revenue,		--for Reservation Revenue
		@BookedDate BookDate,
		orgBCD.Organization,		
		Coupon_Description,
        orgBCD.AR_Customer_Code,	--70
		IsNull(orgBCD.Tour_Rate_Account,0) Tour_Rate_Account,
		IsNull(orgBCD.Maestro_Rate_Override,0) Maestro_Rate_Override,
		resv.BCD_Number,	
		org.organization,
		resv.Flat_Discount
		

	FROM	Reservation resv
	LEFT 
	JOIN	Organization org  -- refering org
	  ON	resv.Referring_Org_Id = org.organization_id
	left join Organization orgBCD on resv.bcd_number=orgbcd.bcd_number
	LEFT 
	JOIN	Organization OrgBCDRate  -- BCD Rate org
		ON	resv.BCD_Rate_Org_Id = OrgBCDRate.organization_id
	left join reservation_coupon RC on RC.Coupon_Number=resv.Coupon_Code
	left Join Reservation_Dep_Payment RDP On resv.Confirmation_Number=RDP.Confirmation_Number
--			AND ( (resv.Pick_Up_On between RC.Effective_Date and RC.Terminate_Date)
--					 or (RC.Effective_Date is null))

	WHERE 	resv.Confirmation_Number = @iConfirmNum

	RETURN @@ROWCOUNT
 
GO
