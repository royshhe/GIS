USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetUserSessionList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 19, 2002
----  Details:	 get user session list
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecGetUserSessionList]
as

SET XACT_ABORT on
SET NOCOUNT ON

select 
	uc.user_id , 
	u.user_name , 
	( case when id.screen_description is null then
		uc.last_screen_id 
	  else
		id.screen_description
	  end
	) as screen_description ,
	uc.last_updated_on 
from gisusercache uc
join gisusers u
	on u.user_id = uc.user_id
left join gisscreenIDs id
	on id.screen_id = uc.last_screen_id
order by uc.user_id , uc.last_updated_on 

SET XACT_ABORT off
SET NOCOUNT Off



GO
