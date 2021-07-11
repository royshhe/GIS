USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxUpdateAutoFaxContract]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






-----------------------------------------------------------------------------------------------------
-----    Programmer:   Jack Jian
-----    Date:              Apr 05, 2001
----     Details:	     Update status of autofaxcontract table
-----------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxUpdateAutoFaxContract]

	@control_ID int ,
	@status int ,   -- 300002 achieved ok ( the last status in autofaxcontract table)
	@copy_sequence int ,
	@user_name varchar(255)

as

	update autofaxcontract 

	set process_status = @status , 
	      copy_sequence = @copy_sequence ,
	      try_times = try_times + 1 ,
	      last_updated_by = @user_name ,
	      last_updated_on = getdate()

	where  control_ID = @control_ID




GO
