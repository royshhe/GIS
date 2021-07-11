USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecUpdateScreenPermissionList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Sharon Li
----  Date: 	 Jul 11, 2005
----  Details:	 update screen permission list
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecUpdateScreenPermissionList]
	@screen_number varchar(50) ='' ,
	@permission_desc varchar(50) ='',
	@add_permission int = 0
as

SET XACT_ABORT on
SET NOCOUNT ON

declare @permission_id int 
select @permission_id =
	(select  permission_id from GISPermissionIDs
	where permission_description = @permission_desc
	)

if @add_permission = 1
begin
	if not exists (select 1 from gisScreenFieldPermissions where screen_number = @screen_number and permission_id = @permission_id)
		insert into gisScreenFieldPermissions ( [screen_number] , permission_id , last_updated_by , last_updated_on ) values ( @screen_number , @permission_id , 'GISSAdmin' , getdate() )
end
else
if @add_permission = -1
begin
	delete from gisScreenFieldPermissions where screen_number = @screen_number and permission_id = @permission_id
end

SET XACT_ABORT off
SET NOCOUNT Off





GO
