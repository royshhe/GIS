USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISUserScreenACL]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Dec 21, 2001
----  Details:	 For new GIS Security solutions, create brand new user permission structure
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetGISUserScreenACL]
	@user_hash varchar(36) ='' ,
	@screen_id varchar(255)   ,
	@active int = 1
as

SET XACT_ABORT on
SET NOCOUNT ON

select   
	distinct u.permission_id  , 
	s.screen_id , 
	v.user_name ,
	v.user_id
from 
( 
	SELECT  uc.user_id, 
		iu.active ,
		iu.is_NT_account,
		iu.user_name ,
		iug.group_name
	FROM gisusercache uc
	join gisusers iu on uc.user_id = iu.user_id
	join gisusergroup iug on uc.user_id = iug.user_id
	where uc.user_hash = @user_hash
) v
join gisusergrouppermissions u
	 on v.group_name = u.group_name
join gisscreenIDs s
	 on s.screen_number = u.screen_number
where 
	v.active = @active and
	((s.screen_id = @screen_id and @screen_id<>'') or @screen_id ='' ) and
	u.permission_id in ( select sp.permission_id 
			           from gisscreenids isi 
			           join gisscreenfieldpermissions sp on isi.screen_number = sp.screen_number 
			          where (( isi.screen_id = @screen_id and @screen_id <> '') or @screen_id = '') )
	and u.permission_id in ( select permission_id
			          from gispermissionIDs )
	and v.group_name in (select group_name from gisusergroups)

order by s.screen_id

-- update user time stamp ...
if @screen_id <> '' 
	exec SecUpdateUserHashTimeStamp @user_hash , @screen_id

SET XACT_ABORT off
SET NOCOUNT Off









GO
