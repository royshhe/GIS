USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetUserRptACLByScreenID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 03, 2002
----  Details:	 Get user report acl
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecGetUserRptACLByScreenID]
	@report_hash varchar(36) ='' ,
	@screen_id varchar(255) 
as

SET XACT_ABORT on
SET NOCOUNT ON

declare 	@user_hash_db varchar(255)

select 	@user_hash_db = user_hash 
from 	gisusercache
where 	report_hash = @report_hash

-- update user time stamp ...
exec SecUpdateUserHashTimeStamp @user_hash_db , @screen_id

exec SecGetGISUserScreenACL @user_hash_db , @screen_id , 1

SET XACT_ABORT off
SET NOCOUNT Off




GO
