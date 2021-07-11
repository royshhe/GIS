USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecDeleteUserByID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Apr 27, 2002
----  Details:	 Delete GIS user by ID
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecDeleteUserByID]
	@user_id varchar(255) 
as

	SET XACT_ABORT on
	SET NOCOUNT ON

	delete from gisusercache 
	where user_id = @user_id
	
	delete from gisusergroup 
	where user_id = @user_id

	delete from gisusers
	where user_id = @user_id

	SET NOCOUNT Off
	SET XACT_ABORT off






GO
