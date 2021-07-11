USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecUpdateUserHashTimeStamp]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Dec 21, 2001
----  Details:	 update user hash time stamp
-------------------------------------------------------------------------------------------------------------------
--drop PROCEDURE SecUpdateUserHashTimeStamp
--go
CREATE PROCEDURE [dbo].[SecUpdateUserHashTimeStamp]

	@user_hash varchar(255)  ,
	@screen_id varchar(255) = ''
as

	SET NOCOUNT ON	

	if @screen_id = '' 
		set @screen_id = 'Unknown'

	update 	gisUsercache
	set 	last_updated_on = getdate() ,
		last_screen_id = @screen_id
	where user_hash = @user_hash

	SET NOCOUNT Off




GO
