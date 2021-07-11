USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecAddGroup]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 19, 2002
----  Details:	add gis group
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecAddGroup]
	@group_name varchar(255) 
as
	SET NOCOUNT ON

	if not exists ( select 1 from gisusergroups where group_name = @group_name)
	
	insert into gisusergroups ( group_name ,
		last_updated_by ,
		last_updated_on )
	values (
		@group_name ,
		'GISSAdmin' ,
		getdate() )

	SET NOCOUNT Off


GO
