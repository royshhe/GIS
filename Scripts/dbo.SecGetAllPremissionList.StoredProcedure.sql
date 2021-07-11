USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetAllPremissionList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 17, 2002
----  Details:	 Get all gis permission list
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetAllPremissionList]


as

	SET NOCOUNT ON	

	select 

		id.screen_id , 
		sf.permission_id , 
		id.screen_description , 

		id.screen_type ,
		(
			case when id.screen_type = 2 then
				'Scheduled Reports'
			else
				id.screen_cat 
			end
		) as screen_cat ,

		pid.permission_description 
	from 	gisscreenIDs  id
	join 	gisScreenFieldPermissions sf
		on id.screen_number = sf.screen_number
	join 	gispermissionids pid
		on sf.permission_id = pid.permission_id
	
	where id.screen_type >= 0
	order  by id.screen_type , screen_cat , id.screen_id ,  sf.permission_id


	SET NOCOUNT Off




GO
