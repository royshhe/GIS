USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISUserList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 14, 2002
----  Details:	 Get GIS User list
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetGISUserList]

	@user_id varchar(255)  = '' ,
	@active int = 1 

as

	SET NOCOUNT ON	

	select user_id, user_name
	from gisusers
	where ((user_id = @user_id and @user_id <> '') or @user_id = '')
		and (active = @active or @active = -1 )
		and user_password not like '%xx'
	order by user_name

	SET NOCOUNT Off






GO
