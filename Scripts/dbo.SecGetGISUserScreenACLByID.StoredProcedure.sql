USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISUserScreenACLByID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 14, 2002
----  Details:	 get gis user ACL list by ID and screen id
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetGISUserScreenACLByID]
	@user_id varchar(50) ='' ,
	@screen_id varchar(255)   ,
	@active int = 1
as

SET XACT_ABORT on
SET NOCOUNT ON

select   
	distinct u.permission_id  , 
	s.screen_id , 
	s.screen_description,
	s.screen_type ,
	(
		case when s.screen_type = 2 then
			'Scheduled Reports'
		else
			s.screen_cat 
		end
	) as screen_cat ,
	gid.permission_description
from 
( 
	SELECT  iu.user_id, 
		iu.active ,
		iu.is_NT_account,
		iu.user_name ,
		iug.group_name
	FROM gisusers iu 
	join gisusergroup iug on iu.user_id = iug.user_id
	join gisusergroups iugs on iugs.group_name = iug.group_name
	where iu.user_id = @user_id
) v
join gisusergrouppermissions u
	 on v.group_name = u.group_name
join gisscreenIDs s
	 on s.screen_number = u.screen_number
join  gispermissionIDs gid
	on gid.permission_id = u.permission_id
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
	and s.screen_type >= 0

order by s.screen_type , screen_cat , s.screen_id

SET XACT_ABORT off
SET NOCOUNT Off







GO
