USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdhocReportForBCRail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Jun 01, 2001
--  Details: 	 Create special adhoc report for BC Rail
--  Tracker:	 Issue# 1847
---------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetAdhocReportForBCRail]

	@StartDate varchar(255) = 'May 01 2001' ,
	@enddate   varchar(255) = 'May 31 2001' ,
	@company_name varchar(255) = 'BC Rail'

as

	declare @startdate_d  datetime
	declare @enddate_d datetime
 
	select @startdate_d = convert( datetime , @StartDate )
	select @enddate_d = convert( datetime ,  @enddate ) + 1

PRINT '--------------------- Monthly Report For '+ @company_name +'  ----------------------'
PRINT '*** Reporting Period From: '+ @StartDate +' To: '+ @enddate  +'  ***' 
PRINT '*** Generated At: ' + CONVERT(VARCHAR(30), GETDATE())+'  ***'
PRINT ''

	select 
		tcon.contract_number as 'Contract Number' ,
		con.Pick_Up_On as 'Pick Up Date' , 
		locup.location  as 'Pick Up Location' ,
		con.Last_Name as 'Customer Last Name',
		con.First_Name as 'Customer First Name' ,
		voc.unit_number as 'Unit Number' ,
		vmy.Model_Name as 'Vehicle Model' ,
		vmy.Model_Year as 'Model Year'
	from 
		( 
			select voc.contract_number
			from vehicle_on_contract voc 
			inner join contract con
			on con.contract_number = voc.contract_number 
				and con.company_name = @company_name
--				and con.company_name in ('B C RAIL' , 'B C RAIL LTD' ,  'B.C. RAIL' ,  'bc rail' , 'BC RAIL LTD' ,  'bcrail' )
				and con.status = 'CI'
			group by voc.contract_number 
			having max(voc.Actual_Check_In) between @startdate_d  and @enddate_d
		) tcon

	join contract con
		on tcon.contract_number = con.contract_number 
	left join location locup
		on con.Pick_Up_Location_ID = locup.Location_ID
	left join vehicle_on_contract voc
		on con.contract_number = voc.contract_number
	left join vehicle v
		on v.unit_number = voc.unit_number
	left join Vehicle_Model_Year vmy
		on v.Vehicle_Model_ID = vmy.Vehicle_Model_ID

	order by con.Pick_Up_On







GO
