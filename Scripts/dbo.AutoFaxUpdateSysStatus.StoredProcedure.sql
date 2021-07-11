USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxUpdateSysStatus]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              Apr 10, 2001
-----  Details:            update system status
----------------------------------------------------------------------------------------------------------------------------------------------------------
 

CREATE PROCEDURE [dbo].[AutoFaxUpdateSysStatus]
	
	@contraol_ID int ,
	@system_status varchar(255)  ,
	@user_name varchar(255) 

as

	update autofaxcontrol 
	set control_value = @system_status , 
		last_updated_by = @user_name , 
		last_updated_on = getdate()
	where control_ID = @contraol_ID



GO
