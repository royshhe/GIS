USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetContract]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetContract    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.GetContract    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve the contract information for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetContract] -- 1722772
        @ContractNum Varchar(11)
AS
        /* 2/20/99 - cpy modified - added placeholder */
	-- Don K - Aug 11 1999 - Added bcd org name
	-- NP	- Sep 27 1999 - Added FF_Assigned_Date
	/* 9/30/99 - do type conversion outside of select */

DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(int, NULLIF(@ContractNum,''))

        SELECT  distinct
				ctrct.Contract_Number,
                ctrct.Confirmation_Number,
                ctrct.Customer_Program_Number,
                ctrct.Pick_Up_Location_ID,
                Convert(Varchar(11), ctrct.Pick_Up_On, 13) as Pick_Up_On,   -- PUD

                Convert(Varchar(5), ctrct.Pick_Up_On,  114) as Pick_Up_On_Time,  -- PUT
                ctrct.Drop_Off_Location_ID,
                Convert(Varchar(11), ctrct.Drop_Off_On, 13) as Drop_Off_Date,  -- PUD
                Convert(Varchar(5), ctrct.Drop_Off_On,  114) as Drop_Off_Time, -- PUT
                ctrct.Vehicle_Class_Code,

                Convert(Char(1), ctrct.Renter_Driving) as Renter_Driving,
                ctrct.Birth_Date,
                ctrct.Customer_ID,
                ctrct.Last_Name,
                ctrct.First_Name,

                ctrct.Gender,
                ctrct.Phone_Number,
                ctrct.Address_1,
                ctrct.Address_2,
                ctrct.City,

                ctrct.Province_State,
                ctrct.Country,
                ctrct.Postal_Code,
                ctrct.Fax_Number,
                ctrct.Email_Address,

                ctrct.Smoking_Non_Smoking,
                ctrct.Company_Name,
                ctrct.Company_Phone_Number,
                ctrct.Local_Phone_Number,
                ctrct.Local_Address_1,

                ctrct.Local_Address_2,
                ctrct.Local_City,
                Convert(Char(1), ctrct.Do_Not_Extend_Rental) as Do_Not_Extend_Rental,
                ctrct.Do_Not_Extend_Reason,
                ctrct.Rate_Id,

                ctrct.Rate_Assigned_Date,
                ctrct.Rate_Level,
                ctrct.Flex_Discount,
                ctrct.Member_Discount_ID,
                ctrct.Frequent_Flyer_Plan_ID,

                ctrct.LDW_Declined_Reason,
                ctrct.LDW_Declined_Details,
                ctrct.Pre_Authorization_Method,
                ctrct.Referring_Organization_ID,
                ctrct.BCD_Rate_Organization_ID,

                ctrct.IATA_Number,
                ctrct.Referring_Employee_Id,
                ctrct.Update_Ctrl,
                ctrct.Print_Comment,
                Convert(Char(1), ctrct.Copied) Copied,

                ctrct.Status,
                Convert(Char(1), ctrct.Apply_Violation_Rate) Apply_Violation_Rate,
                ctrct.Sub_Vehicle_Class_Code,
                Convert(Char(1), ctrct.Do_Not_Replace_Vehicle) Do_Not_Replace_Vehicle,
                ctrct.Last_Update_By,

                ctrct.Last_Update_On,
                ctrct.FF_Member_Number,
                ctrct.Quoted_Rate_ID,
                ctrct.Foreign_Contract_Number,
                ctrct.Contract_Currency_ID,

                ctrct.Percentage_Tax1,
                ctrct.Percentage_Tax2,
                ctrct.Daily_Tax,
                ctrct.Interbranch_Balance,
                ctrct.GST_Exempt_Num,

                ctrct.PST_Exempt_Num,
                '',      -- placeholder for OverrideTruckAvailCheck flag,
		org.organization,
		ctrct.FF_Assigned_Date,
		Convert(Char(1), ctrct.Override_Minimum_Age) Override_Minimum_Age,
		Convert(Char(1), ctrct.Opt_Out) Opt_Out,
		(case
		When Reservation.Foreign_Confirm_Number is not null then
			Reservation.Foreign_Confirm_Number
		else
			Convert(Char(20),Reservation.Confirmation_Number)	
		End) as ResConfirmationNumber,
		(Case When Reservation.BCD_Number is not null then Reservation.BCD_Number
		      Else BCDRateorg.BCD_Number
		End) as BCD_Number,
		Reservation.Coupon_code,
		Convert(Char(1),  ctrct.FF_Swiped) FF_Swiped,
	   ctrct.AM_Coupon_Code,
	   (Case When Reservation.Coupon_Description is Not Null then Reservation.Coupon_Description
	   Else	   
		  (Case When (ReservationCoupon.CouponDescription2 is not null) And ( (ctrct.Pick_Up_On between ReservationCoupon.Effective_Date and ReservationCoupon.Terminate_Date) or (ReservationCoupon.Effective_Date is null))
					Then ReservationCoupon.CouponDescription2
					When  ReservationCoupon.CouponDescription2 is not null  And ctrct.Pick_Up_On >ReservationCoupon.Terminate_Date 
					Then 'Coupon Expired. Valid Period: '+CONVERT(VarChar, ReservationCoupon.Effective_Date, 111) +' - '+ CONVERT(VarChar, ReservationCoupon.Terminate_Date, 111)
					Else ''
		   End) 
	   End)     CouponDescription,
       --Reservation.Coupon_Description,
  	   Reservation.Pick_Up_On,
       Reservation.Drop_Off_On,
	   Reservation.AR_Customer_Code,
	   Reservation.CID,
	   Reservation.Tour_Rate_Account,
	   Reservation.Maestro_Rate_Override,
	   Convert(Char(1), ctrct.Arrived_Through_AP) Arrived_Through_AP,
	   ctrct.PVRT_Exempt_Num,
	   Reservation.Flat_Discount,
	   PULoc.IsAirportLocation,
	   --For Interim Billing
	   Tot.GSTRate,
	   Tot.PSTRate
	  
FROM         dbo.Contract ctrct 
       -- this will be kept for transition period of time. 20131112 rhe
       inner join dbo.Location PULoc on    ctrct.Pick_Up_Location_ID=  PULoc.Location_ID
       
		LEFT 	OUTER JOIN 
       (
        SELECT     ResCoupon.Description_1 AS CouponDescription1, ResCoupon.Description_2 AS CouponDescription2, ResCoupon.Effective_Date, 
                      ResCoupon.Terminate_Date, Res.Confirmation_Number, Res.Coupon_code
		FROM     dbo.Reservation Res Left Join dbo.Reservation_Coupon ResCoupon ON Res.Coupon_Code =ResCoupon.Coupon_Number  
		where Res.Coupon_Code is not null
        ) ReservationCoupon
       
		ON (ctrct.Confirmation_Number = ReservationCoupon.Confirmation_Number) 
			AND ( (ctrct.Pick_Up_On between ReservationCoupon.Effective_Date and ReservationCoupon.Terminate_Date) or (ReservationCoupon.Effective_Date is null))
        LEFT OUTER JOIN  
		(
				SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, 
								  dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, dbo.Reservation.Coupon_Description,dbo.Reservation.flat_discount, dbo.Organization.AR_Customer_Code, 
								   IsNull(dbo.Organization.Tour_Rate_Account,0) Tour_Rate_Account,
								   IsNull(dbo.Organization.Maestro_Rate_Override,0) Maestro_Rate_Override,
								   dbo.Reservation.CID
				FROM         dbo.Reservation LEFT OUTER JOIN   dbo.Organization ON dbo.Reservation.BCD_Number = dbo.Organization.BCD_Number
		) Reservation 
		ON ctrct.Confirmation_Number = Reservation.Confirmation_Number
		LEFT OUTER JOIN dbo.Organization org 
		ON ctrct.Referring_Organization_ID = org.Organization_ID
		LEFT OUTER JOIN dbo.Organization BCDRateorg 
		ON ctrct.BCD_Rate_Organization_ID = BCDRateorg.Organization_ID
		Left JOIN         
			(	   SELECT Contract_Number,  
						  case when SUM(Amount-GST_Amount_Included - PST_Amount_Included)=0
									then 0
									else  SUM(GST_Amount + GST_Amount_Included)/SUM(Amount-GST_Amount_Included - PST_Amount_Included)
							end GSTRate,
						  case  when SUM(Amount-GST_Amount_Included - PST_Amount_Included)=0 
									then 0
									else Sum(PST_Amount+  PST_Amount_Included)/SUM(Amount-GST_Amount_Included - PST_Amount_Included) 
							end PSTRate
					 
				FROM   (SELECT Contract_Number, Amount,GST_Amount,PST_Amount,PVRT_Amount,GST_Amount_Included,  PST_Amount_Included
								FROM   dbo.Contract_Charge_Item AS cci
								UNION ALL
								SELECT Contract_Number, Flat_Amount * - 1 AS Amount,0 GST_Amount,0 PST_Amount,0 PVRT_Amount, 0 GST_Amount_Included, 0 PST_Amount_Included
								FROM  dbo.Contract_Reimbur_and_Discount AS cci
						) AS Con
										 
				 
				Group by  Contract_Number
			  ) AS Tot ON ctrct.Contract_Number = Tot.Contract_Number
        WHERE   ctrct.Contract_Number = @iCtrctNum
        RETURN @@ROWCOUNT

 



 
SET ANSI_NULLS OFF

GO
