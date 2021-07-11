USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISUserReportACL]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 02, 2002
----  Details:	 Get user report acl
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecGetGISUserReportACL]
	@user_hash varchar(36) ='' ,
	@run_report_permission_id int = 250 ,
	@active int = 1, 
	@report_type int = 1 -- 1 - on request report,  2- schedule report
as

SET XACT_ABORT on
SET NOCOUNT ON

declare 	@user_hash_report_db varchar(255)
declare @screen_id varchar(255)

select 	@user_hash_report_db = report_hash 
from 	gisusercache
where 	user_hash = @user_hash

if @report_type = 1
	set @screen_id = 'On Request Report Main Menu'
else
	set @screen_id = 'Scheduled Report Main Menu'

-- update user time stamp ...
exec SecUpdateUserHashTimeStamp @user_hash , @screen_id

select sid.screen_id, sid.screen_cat , sid.screen_description , sid.screen_path , @user_hash_report_db as 'report_hash'
from gisscreenIDs sid
where sid.screen_number in (
	select 	distinct ugp.screen_number 
	from 	gisusergrouppermissions ugp
	join
		 ( select group_name 
		   from gisusergroup 
		   where  user_id = 
			( select distinct iuc.user_id 
			  from gisusercache  iuc , gisusers iu
			  where  iuc.user_hash = @user_hash 
				and iu.active = @active
			) 
		) usergroups
	on ugp.group_name = usergroups.group_name
	where ugp.permission_id = @run_report_permission_id
)

	and sid.screen_type = @report_type
order by sid.screen_cat , sid.screen_id--sid.screen_description

SET XACT_ABORT off
SET NOCOUNT Off


















GO
