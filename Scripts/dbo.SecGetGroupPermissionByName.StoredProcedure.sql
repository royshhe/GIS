USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGroupPermissionByName]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 17, 2002
----  Details:	 Get GIS User list
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetGroupPermissionByName]

	@group_name varchar(255)  = '' 
as

	SET NOCOUNT ON	


	select 
		id.screen_cat , 
		id.screen_id , 
		id.screen_type ,
		gp.permission_id 
	from 	gisusergrouppermissions   gp
	join 	gisscreenIDs id
	on 	id.screen_number = gp.screen_number
	where 	group_name = @group_name 
		and id.screen_type >= 0
	order by 
		id.screen_type ,  
		id.screen_cat 

	SET NOCOUNT Off





GO
