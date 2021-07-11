USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetScreenPermissionByNumber]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 18, 2002
----  Details:	 Get GIS screen predefined permission
----  Mod by: 	Sharon Li	Jul 11, 2005
----  Purpose:	Get screen permission with checkbox

-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetScreenPermissionByNumber] --'1220'
	@screen_number varchar(255)
as

	SET NOCOUNT ON	

	select distinct gpids.permission_description,
		(
		case
			when exists (select distinct permission_id from gisScreenFieldPermissions where screen_number = @screen_number and permission_id = gpids.permission_id) then
				1
			when (not exists (select distinct permission_id from gisScreenFieldPermissions where screen_number = @screen_number and permission_id = gpids.permission_id)) then
				0
		end) as 'selected'

	from gisScreenFieldPermissions gp
	right join gispermissionids gpids  on 
		gp.permission_id = gpids.permission_id 
	--where gp.screen_number = @screen_number
	order by permission_description

	SET NOCOUNT Off
GO
