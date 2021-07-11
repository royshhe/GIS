USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecUpdateUserGroupList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 15, 2002
----  Details:	 update user group list
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecUpdateUserGroupList]
	@user_id varchar(50) ='' ,
	@group_name varchar(255) ,
	@add_group int = 0
as

SET XACT_ABORT on
SET NOCOUNT ON

if @add_group = 1
begin
	if not exists (select 1 from gisusergroup where user_id = @user_id and group_name = @group_name)
		insert into gisusergroup ( [user_id] , group_name , last_updated_by , last_updated_on ) values ( @user_id , @group_name , 'GISSAdmin' , getdate() )
end
else
if @add_group = -1
begin
	delete from gisusergroup where user_id = @user_id and group_name = @group_name
end

SET XACT_ABORT off
SET NOCOUNT Off




GO
