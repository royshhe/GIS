USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxUpdateAutoFaxRecordByID]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              May 28, 2001
--  Details: 	 update fax record
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxUpdateAutoFaxRecordByID]

	@control_id int ,
	@process_status int ,
	@control_Status int ,
	@last_updated_by varchar(255)

As
	update 
		autofax 
	set 
		process_status = @process_status  ,
		send_try_times = convert(int, send_try_times) + 1 ,
		control_status = @control_status ,
		last_updated_by = @last_updated_by ,
		last_updated_on = getdate()
	where 
		fax_control_id = @control_id 
	



GO
