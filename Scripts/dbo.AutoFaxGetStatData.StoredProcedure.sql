USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetStatData]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 17, 2001
--  Details: 	 get statistics data
----------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetStatData]


as

	select 
		( select count(*) from autofaxlog where message_id = 300002 ) as contract_record_achieve_ok ,
		( select count(*) from autofaxlog where message_id = 300001 ) as print_to_fax_fail  ,
		( select count(*) from autofaxlog where message_id = 300003 ) as achieve_pcl_fail ,
		( select count(*) from autofaxlog where message_id = 300005 ) as fax_record_create_fail ,

		( select count(*) from autofaxlog where message_id = 400000 ) as fax_send_request_ok ,
		( select count(*) from autofaxlog where message_id = 400001 ) as fax_request_fail ,
		( select count(*) from autofax     where process_status = 499999 ) as fax_process_ok ,

		( select count(*) from autofax ) as fax_total 
--		( select count(*) from autofax )  as fax_total 

	






GO
