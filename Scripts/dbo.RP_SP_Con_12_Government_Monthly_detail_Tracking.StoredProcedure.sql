USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_12_Government_Monthly_detail_Tracking]    Script Date: 2021-07-10 1:50:50 PM ******/
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

CREATE PROCEDURE [dbo].[RP_SP_Con_12_Government_Monthly_detail_Tracking] --'01 oct 2010', '02 oct 2010'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



SELECT Contract_Number,
--		res.foreign_confirm_number,
--	month(rbr_date) as "Month",
--    	RBR_Date,     	
	Organization_name,
	con.BCD_number as BCD_Number,		
	Rate_name,
	ceiling(Contract_Rental_Days) as Contract_rental_days,
      	TimeCharge,
	KMCharge,
	convert(varchar(30),Vehicle_Class_Name) as Vehicle_Class_Name,
	model_year as "Year",
	model_name as Model,
	(con.First_name +' , '+ con.Last_name) as "Renter Name",
 	con.Company_name as "Renter's Department",
       	LocationName as "Location of Rental",
	con.Pick_Up_On as "Date of Rental",
	KmDriven as "Kilometers Driven",
	do_location


FROM Contract_Revenue_Goverment_Tracking_sum_vw con left outer join reservation  res
		on con.confirmation_number=res.confirmation_number
where rbr_date between @paramStartDate and @paramEndDate
order by Pu_location,con.company_name,contract_number


GO
