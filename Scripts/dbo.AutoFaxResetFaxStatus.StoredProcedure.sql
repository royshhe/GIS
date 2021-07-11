USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxResetFaxStatus]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              May 08, 2001
--  Details: 	 reset fax status
----------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[AutoFaxResetFaxStatus]

	@response_id int ,
	@fax_number varchar(255) ,
	@reciever_id varchar(255) ,
	@process_status int ,
	@user_name varchar(255)

as

	update autofax 

	set response_id = 0 ,
 	      process_status = @process_status ,
	      send_try_times = 0 ,
	      control_status = 0 ,    		-- 0 - enabled ; 1- disabled
	      last_updated_by = @user_name ,
	      last_updated_on = getdate()

	where response_id = @response_id

		and ( reciever_fax_no = @fax_number or @fax_number = '' )
		and reciever_id = @reciever_id






GO
