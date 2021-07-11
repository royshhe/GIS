USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecDeleteUserGroup]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Apr 27, 2002
----  Details:	 Delete GIS user group
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecDeleteUserGroup]
	@group_name 	varchar(255)
as
	SET XACT_ABORT on
	SET NOCOUNT ON
	
	delete gisusergroup
	where group_name = @group_name

	delete gisusergrouppermissions
	where group_name = @group_name

	delete gisusergroups
	where group_name = @group_name

	SET NOCOUNT Off
	SET XACT_ABORT off




GO
