USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxListByFaxNo]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 30,  2001
--  Details: 	 get pending faxs list to fax
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxListByFaxNo]
 
	@fax_number varchar(255) ,

	@process_status int ,  		-- attachments missing status 500001
	@max_send_try_times int ,
	@control_status int = 0
as

	select 
		fax_control_ID ,
		ref_control_ID ,
		contract_number ,
		contract_rbr_date ,
		send_try_times ,
		pcl_file_name ,
		reciever_id ,
		reciever_name ,

		sender_full_name ,
		sender_comany_name ,
		sender_tele_no ,
		send_fax_no ,
		sender_voice_no
	from 
		autofax
	where 
		( response_id = 0  or process_status = @process_status )
		and send_try_times < @max_send_try_times
		and reciever_fax_no = @fax_number 
		and control_status = @control_status
	order by 
		contract_rbr_date ,
		 ref_control_ID , 
		fax_control_id






GO
