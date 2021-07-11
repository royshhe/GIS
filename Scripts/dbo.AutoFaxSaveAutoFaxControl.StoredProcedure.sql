USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxSaveAutoFaxControl]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              May 02, 2001
--  Details: 	 Save AutoFax Service Control Infomation 
------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxSaveAutoFaxControl] 
	@control_ID int ,
	@control_value varchar(255) ,
	@user_name varchar(255)

as

	if exists( select * 
		from autofaxcontrol 
		where control_id = @control_id)

                          update autofaxcontrol 
		set 
		control_value = @control_value  ,
		last_updated_on = getdate() ,
		last_updated_by = @user_name
		where control_id = @control_id
	else
		insert into autofaxcontrol 
		( control_ID , 
		control_description , 
		control_value , 
		control_active , 
		last_updated_on , 
		last_updated_by )
		values
		( @control_ID ,
		null ,
		@control_value ,
		'Y' ,
		getdate() ,
		@user_name )



GO
