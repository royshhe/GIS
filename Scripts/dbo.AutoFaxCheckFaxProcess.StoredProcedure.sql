USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCheckFaxProcess]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              Apr 20, 2001
-----  Details:            Check the fax process 
----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[AutoFaxCheckFaxProcess]
	
	@max_send_try_times int  = 3 , 
	@check_return bit output

as
	
	if exists ( 
  			select * 
			from autofax 
			where send_try_times < @max_send_try_times 
				and response_id = 0 
				and control_status = 0
		)
		set @check_return = 1
	else
		set @check_return = 0




GO
