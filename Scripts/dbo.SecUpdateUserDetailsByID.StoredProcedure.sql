USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecUpdateUserDetailsByID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 15, 2002
----  Details:	 update user group list
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecUpdateUserDetailsByID]
	@is_new int = 0 ,
	@user_id varchar(50)  ,
	@user_name varchar(200),
	@user_password varchar(50) ,
	@user_desc varchar(200) ,
	@employeeID varchar(50),
	@departmentID int=NUll,--This is one cause GISS update problem.
	@nt_account int ,
	@active int,
	@return int output 
as

SET XACT_ABORT on
SET NOCOUNT ON
	if @is_new = 1
	begin
		 if exists( select * from gisusers where user_id = @user_id or user_name = @user_name)
			set @return = 0
		else
		begin
			insert into gisusers ( user_id , user_name , user_password, user_description , EmployeeID,Department_ID,is_NT_account , active )
				values     ( @user_id , @user_name , @user_password , @user_desc ,@employeeID,@departmentID, @nt_account , @active )
			set @return = 1
		end
	end
	else
	begin
		update gisusers 
		set user_password = @user_password , user_description = @user_desc ,EmployeeID= @employeeID,Department_ID=@departmentID, is_NT_account = @nt_account , active = @active
		where user_id = @user_id and user_name = @user_name
		set @return = 1
	end

SET XACT_ABORT off
SET NOCOUNT Off









GO
