USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISUserPassword]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Aug 31, 2001
----  Details:	 Get GIS User info
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetGISUserPassword] 

	@user_id varchar(255) ,
	@active int = 1 ,
	@userOldHash varchar(255),
	@user_password varchar(255) output,
	@user_hash varchar(255) output

as

	SET NOCOUNT ON	

	select @user_password = user_password 
	from gisusers
	where user_id = @user_id
		and active = @active

	if @@rowcount <> 1
		set @user_password = ''

	
	select @user_hash = user_hash
	from GISUserCache
	where user_hash = @userOldHash
		and user_id = @user_id

	if @@rowcount <> 1
		set @user_hash = ''

	SET NOCOUNT Off


GO
