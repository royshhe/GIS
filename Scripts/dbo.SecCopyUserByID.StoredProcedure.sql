USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecCopyUserByID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Apr 27, 2002
----  Details:	 Delete GIS user by ID
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecCopyUserByID]
	@from_user_id 	varchar(255) ,
	@to_user_id 	varchar(255) ,
	@to_user_name 	varchar(255) 
as
	SET XACT_ABORT on
	SET NOCOUNT ON
	
	declare @user_password 		varchar(255)
	declare @is_NT_account 		bit
	declare @active 		bit
	declare @user_description  	varchar(255) 
	
	select 
		@user_password = user_password,
		@is_NT_account = is_NT_account,
		@active = active,
		@user_description = user_description
	from gisusers
	where user_id = @from_user_id

	insert into gisusers 
	(
		user_id,
                user_name,
                user_password,
		active,
                is_NT_account,
                user_description
	)
	values
	(
		@to_user_id,
		@to_user_name,
		@user_password,
		@active,
		@is_NT_account,
		@user_description
	)
	
	select user_id, group_name , last_updated_by , last_updated_on
	into #temp
	from gisusergroup
	where user_id = @from_user_id

	update #temp
	set user_id = @to_user_id ,
	    last_updated_by = 'GISSAdmin' , last_updated_on = getdate()
	
	insert into gisusergroup
	(user_id, group_name , last_updated_by , last_updated_on)
	select user_id, group_name , last_updated_by , last_updated_on
	from #temp

	SET NOCOUNT Off
	SET XACT_ABORT off




GO
