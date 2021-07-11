USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecCreateUserHash]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Dec 18, 2001
----  Details:	 create userhash
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecCreateUserHash]
	@user_id varchar(255) ,
	@user_hash varchar(255) output
as
	SET NOCOUNT ON

	declare @user_hash_db varchar(255)
	declare @user_hash_report_db varchar(255)

	select @user_hash_db = newid()
	select @user_hash_report_db = newid()

	insert into GISUserCache (
		user_id , 
		user_hash , 
		report_hash ,
		last_screen_id ,
		last_updated_on )
	values (
		@user_id ,
		@user_hash_db ,
		@user_hash_report_db ,
		'System Login' ,
		getdate() )

	set @user_hash = @user_hash_db

	SET NOCOUNT Off








GO
