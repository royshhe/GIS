USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetICBCMonthlyLeaseRpt]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Mar 08 2002
-- Purpose: 	To create a report for ICBC Monthly Lease Rental (Over 28 days rental)
--------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetICBCMonthlyLeaseRpt] --'01 oct 2011','31 oct 2011'

       @MonStartDate varchar(30)='Jan 01 2000',
       @MonEndDate varchar(30)='Dec 31 2000'

as


DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @MonStartDate )
SELECT @EndDate=CONVERT(DATETIME, @MonEndDate )

select 	c.Contract_Number,
	vc.unit_number,
	vmy.Model_Name,
	vmy.Model_Year,
	c.Pick_Up_On,
	vc.Actual_Check_In,
	Rental_days = datediff(dayofyear, c.Pick_Up_On, vc.Actual_Check_In),
	l.location
from contract c inner join location l on c.pick_up_location_id=l.location_id
left join 
RP__Last_Vehicle_On_Contract vc
on c.Contract_Number = vc.Contract_Number
left join 
vehicle v
on vc.unit_number = v.unit_number 
left join 
Vehicle_Model_Year vmy
on v.Vehicle_Model_ID = vmy.Vehicle_Model_ID
left join business_transaction bt
on c.contract_number = bt.contract_number
where bt.Transaction_Description = 'Check in'
and bt.RBR_Date between @StartDate and @EndDate
and datediff(day, c.Pick_Up_On, vc.Actual_Check_In) >= 28
order by c.contract_number



GO
