USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxUpdateContractTryStatus]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 12, 2001
--  Details: 	 update the try times status of contract record
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxUpdateContractTryStatus]

	@control_ID int ,
	@max_try_times int ,
	@ignored_status int ,
	@user_name varchar(255) 

as

	update autofaxcontract 
	set 	try_times = try_times + 1  ,
		last_updated_by = @user_name ,
		last_updated_on = getdate()
	where   control_ID = @control_ID

	update autofaxcontract
	set process_status = @ignored_status
	where control_ID = @control_ID 
		and try_times > @max_try_times



GO
