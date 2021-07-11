USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecUpdateScreenDetails]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Sharon Li
----  Date: 	 Jul 12, 2005
----  Details:	 update screen details 
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecUpdateScreenDetails] 
	@is_new int = 0 ,
	@screen_num varchar(50) ,
	@screen_id  varchar(50),
	@screen_type varchar(50),
	@screen_desc varchar(100) ,
	@menu_item varchar(100),
	@menu_subitem varchar(100) ,
	@screen_cat varchar(100),
	@screen_path varchar(255),
	@return int output 
as

SET XACT_ABORT on
SET NOCOUNT ON
	if @is_new = 1
	begin
		 if exists( select * from GISScreenIDs where screen_number = @screen_num or screen_id = @screen_id)
			set @return = 0
		else
		begin
			insert into GISScreenIDs ( screen_id , screen_type, screen_description , MenuItem, MenuSubItem , screen_cat, screen_path, last_updated_by, last_updated_on)
				values     ( @screen_id , @screen_type , @screen_desc ,@menu_item, @menu_subitem , @screen_cat, @screen_path, 'GISSAdmin', getdate())
			set @return = 1
		end
	end
	else
	begin
		update GISScreenIDs 
		set screen_type = @screen_type , screen_description = @screen_desc ,MenuItem= @menu_item, MenuSubItem = @menu_subitem , screen_cat = @screen_cat, screen_path = @screen_path, last_updated_on = getdate() 
		where screen_number = @screen_num and screen_id = @screen_id
		set @return = 1
	end

SET XACT_ABORT off
SET NOCOUNT Off









GO
