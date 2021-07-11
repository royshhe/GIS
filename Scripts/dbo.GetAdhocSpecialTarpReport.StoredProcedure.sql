USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdhocSpecialTarpReport]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-----------------------------------------------------------------------------------------
--  Programmer:     Jack Jian
--  Date:                Aug 15, 2001
--  Details:             Create special report for tart computing ....
--  Tracker Issue:  1595
-----------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetAdhocSpecialTarpReport]

	@begin_date varchar(255) = 'jun 01 2001' ,
	@end_date varchar(255) = 'jun 30 2001'
as

	declare @begin_date_D datetime
	declare @end_date_d datetime
	SELECT @begin_date_D = CONVERT(DATETIME ,  @begin_date )
	SELECT @end_date_d = CONVERT(DATETIME ,  @end_date ) + 1

PRINT '--------------------- Special Report For TARP Computing   --------------------------'
PRINT '*** Reporting Period From: '+ @begin_date +' To: '+ @end_date +'                           ***' 
PRINT '*** Generated At: ' + CONVERT(VARCHAR(30), GETDATE())+'                                            ***'
PRINT ''

	select 
		con.contract_number , 
		con.IATA_Number ,
		voc.Actual_Check_In as last_vehicle_check_in , 
		bt.Transaction_Date as contract_check_in

	from contract con

	 join vehicle_on_contract voc
	   on voc.contract_number = con.contract_number 
       	        and voc.Actual_Check_In = 
 			(
				select 
					max(Actual_Check_In) 
				from vehicle_on_contract ivoc 
				where ivoc.contract_number = voc.contract_number
			)
	 join business_transaction bt
	   on bt.contract_number = con.contract_number
 	        and bt.Transaction_Description = 'Check in'
	where con.status = 'CI' 
	    and ( bt.Transaction_Date < @begin_date_D or bt.Transaction_Date >= @end_date_d )
	    and bt.Transaction_Date > voc.Actual_Check_In
	    and voc.Actual_Check_In >= @begin_date_D and voc.Actual_Check_In < @end_date_d
	    and con.IATA_Number is not null
		
	order by voc.Actual_Check_In , bt.Transaction_Date




GO
