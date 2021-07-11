USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecValidateUserHash]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Dec 18, 2001
----  Details:	 validate userhash
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecValidateUserHash]
	@user_hash varchar(255) ,
	@screen_id varchar(255) ,
	@result varchar(1) output
as

	SET NOCOUNT On
	SET XACT_ABORT on
	
	declare @user_id varchar(255)

	select @user_id = user_id
	from gisusercache
	where user_hash = @user_hash

	if @@rowcount <> 1
	begin
		set  @result = '0'
	end
	else
	begin
		select * 
		from gisusers
		where user_id = @user_id

		if @@rowcount <> 1
			set @result = '0'
		else
			begin
				set @result = '1'
				exec SecUpdateUserHashTimeStamp @user_hash , @screen_id
			end
	end

	SET XACT_ABORT off
	SET NOCOUNT Off




GO
