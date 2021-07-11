USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_GetCSRIncentiveRevenueMini]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_Acc_17_GetCSRIncentiveRevenueMini] -- '2012-03-01', '2012-03-29'
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	


SELECT 	
	CONVERT(datetime,@paramEndBusDate),
        --csr.EmployeeID,
		csr.active,
		--r1.pick_up_location_id as Location_ID,
	l.Location,
	r1.Vehicle_Type_ID,
-- Combine Monthly Rental with Non-Monthly Rental
--  'Car' Vehicle_Type_ID,
   	case when csr.active = 0
		then r1.CSR_Name + ' (T)'
		else r1.CSR_Name
		end 					as CSR_Name,
   	Count(r1.Contract_number) 			as Contract_In,
	--Sum(r1.Walk_up)					as Walk_Up,
	Sum(case when( 
							   (
									(
									 	 (Rate_Purpose<>'Tour Pkg' or Rate_Purpose is null) 
										 and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
										 and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') 
									     and (rate_name Not Like '%Month%')                                            

									)
									or 
									(r1.All_Level_LDW<>0 or r1.PAI<>0 or r1.RSN<>0 or r1.ELI<>0 or r1.Upgrade<>0)
								)
						)				
						then Contract_Rental_Days
						else 0
	 		end
	     ) 	as Rental_Days,
	sum(case when rate_name in ('MiniL','MiniL WK')
				then contract_rental_days*2
			when rate_name in ('MiniH','MiniH WK')
				then  contract_rental_days*3
			else 0	
		end 	
		)	as MiniPayout
			
--select *	
FROM 	RP_Acc_17_CSR_Incentive_Report_L2 r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id
inner join
(select distinct u.user_id, u.user_name, u.active, u.employeeID
from GISUsers u
) csr
	on csr.user_name = r1.CSR_Name
WHERE	r1.rate_name like 'mini%' and (r1.RBR_Date BETWEEN  @startBusDate and @endBusDate ) 

GROUP BY 	csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id,
		l.Location,
   		r1.CSR_Name,
		r1.Vehicle_Type_ID


GO
