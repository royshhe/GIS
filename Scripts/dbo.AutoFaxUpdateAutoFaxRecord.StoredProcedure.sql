USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxUpdateAutoFaxRecord]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 20, 2001
--  Details: 	 update fax record
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxUpdateAutoFaxRecord]

	@fax_number varchar(255) , 
	@process_status_attachmiss int , 

	@process_status_now int ,
	@max_send_try_times int ,
	@response_id int ,
	@last_updated_by varchar(255)


As

	if @response_id = -1                -- do NOT update response id ( 1- response id not recieved ;  2- only update query status )
		begin
			update 
				autofax 
			set 
				process_status = @process_status_now  ,
				send_try_times = convert(int, send_try_times) + 1 ,
				last_updated_by = @last_updated_by ,
				last_updated_on = getdate()
			where 
				reciever_fax_no = @fax_number 
				and ( response_id = 0  or process_status = @process_status_attachmiss )
				and send_try_times < @max_send_try_times
		end


	else			     -- response id recieved <> 0 	

		begin
			update 
				autofax 
			set 
				response_id = @response_id ,
				process_status = @process_status_now  ,
				send_try_times = convert(int, send_try_times) + 1 ,
				last_updated_by = @last_updated_by ,
				last_updated_on = getdate()
			where 
				reciever_fax_no = @fax_number 
				and ( response_id = 0  or process_status = @process_status_attachmiss )
				and send_try_times < @max_send_try_times			
		end








GO
