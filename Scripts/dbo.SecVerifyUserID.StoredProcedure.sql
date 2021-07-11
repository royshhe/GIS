USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecVerifyUserID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Roy He
----  Date: 	 Aug 31, 2001
----  Details:	 Get GIS User info
-------------------------------------------------------------------------------------------------------------------

create PROCEDURE [dbo].[SecVerifyUserID]

	@user_id varchar(255) 
	
as

	SET NOCOUNT ON	

	select count(*)  
	from gisusers
	where user_id = @user_id
		and active = 1
GO
