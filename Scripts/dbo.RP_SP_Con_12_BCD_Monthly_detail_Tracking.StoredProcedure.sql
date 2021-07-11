USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_12_BCD_Monthly_detail_Tracking]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--select data from Contract_Revenue_Goverment_Tracking_Detail_vw

/*
PURPOSE: 
REQUIRES: 
AUTHOR: Peter Ni
DATE CREATED: Feb 13, 2008
CALLED BY: 
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Con_12_BCD_Monthly_detail_Tracking] -- '01 jul 2009', '31 jul 2009'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



SELECT Contract_Number,
		res.foreign_confirm_number,
	month(rbr_date) as "Month",
    	RBR_Date,     	
        	PU_Location as Location,
	con.Pick_Up_On,
 	con.Company_name,
	Organization_name,
	con.BCD_number,		
	(con.First_name +' , '+ con.Last_name) as Renter,
	ceiling(Contract_Rental_Days) as Contract_rental_days,
	KmDriven,
	Rate_name,
        	TimeCharge,
	KMCharge,
	All_Level_LDW ,  
	PAI,  
	PEC ,
	Vehicle_Class_Name,
	model_name,
	model_year

FROM [Contract_Revenue_BCD_Tracking_sum_vw] con left outer join reservation  res
		on con.confirmation_number=res.confirmation_number
where rbr_date between @paramStartDate and @paramEndDate
order by Pu_location,con.company_name,contract_number





GO
