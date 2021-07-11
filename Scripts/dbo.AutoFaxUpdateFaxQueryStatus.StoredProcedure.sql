USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxUpdateFaxQueryStatus]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              May 01,  2001
--  Details: 	 Updae fax query status
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxUpdateFaxQueryStatus]

	@response_id int ,
	@vsi_result_code int ,
	@unknown_vsi_id int ,
	@user_name varchar(255)

as

	update 
		autofax   
	set 
		process_status = isnull(  (select message_number from autofaxmsg where vsi_result_code = @vsi_result_code)  , @unknown_vsi_id ) ,
		last_updated_by = @user_name ,
		last_updated_on = getdate() 
	where   response_id = @response_id

GO
