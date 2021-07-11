USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecLogoutGIS]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Dec 25, 2001
----  Details:	 Logout GIS
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecLogoutGIS]
	@user_hash varchar(255) 
as

	SET NOCOUNT ON	

	delete from gisusercache	
	where user_hash = @user_hash

	SET NOCOUNT Off


GO
