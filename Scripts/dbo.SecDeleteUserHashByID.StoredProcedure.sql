USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecDeleteUserHashByID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 15, 2002
----  Details:	 update user group list
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecDeleteUserHashByID]
	@user_id varchar(50) ='' 
as

SET XACT_ABORT on
SET NOCOUNT ON

delete from gisusercache where user_id = @user_id or @user_id = ''

SET XACT_ABORT off
SET NOCOUNT Off



GO
