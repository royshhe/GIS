USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetUserGroupListByID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 14, 2002
----  Details:	 Get GIS User group list
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetUserGroupListByID]

	@user_id varchar(255)  = '' 

as

	SET NOCOUNT ON	
	
	if @user_id<> '' 
	begin
	select o_ugs.group_name, 
		(
		case 
			when exists (select distinct ug. group_name from gisusergroup ug join gisusergroups ugs on ug.group_name = ugs.group_name where ug.user_id = @user_id and ug.group_name = o_ugs.group_name) then
				1
			 when ( not exists (select distinct ug. group_name from gisusergroup ug join gisusergroups ugs on ug.group_name = ugs.group_name where ug.user_id = @user_id and ug.group_name = o_ugs.group_name)) then
				0
		end )  as 'selected'

	from gisusergroups o_ugs
	order by o_ugs.group_name
	end
	else
	select * from gisusergroups order by group_name
	SET NOCOUNT Off






GO
