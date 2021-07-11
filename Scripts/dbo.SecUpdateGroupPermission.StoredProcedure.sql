USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecUpdateGroupPermission]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 18, 2002
----  Details:	 update user group permission by name
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecUpdateGroupPermission]
	@group_name varchar(255) ,
	@screen_id varchar(50) ='' ,
	@permission_id varchar(50) ,
	@add_permission int = 0
as

SET XACT_ABORT on
SET NOCOUNT ON

declare @screen_number varchar(50)
select @screen_number = screen_number from gisscreenIDs where screen_id = @screen_id

if @add_permission = 1
begin
	if not exists (select 1 from gisusergrouppermissions where group_name = @group_name and screen_number = @screen_number and permission_id = @permission_id )
		insert into gisusergrouppermissions (group_name , screen_number , permission_id ,  last_updated_by , last_updated_on ) values ( @group_name , @screen_number , @permission_id , 'GISSAdmin' , getdate() )
end
else
if @add_permission = -1
begin
	delete from gisusergrouppermissions where group_name = @group_name and screen_number = @screen_number and permission_id = @permission_id 
end

SET XACT_ABORT off
SET NOCOUNT Off


GO
