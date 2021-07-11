USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetAutoFaxErrorReport]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 27, 2001
--  Details: 	 Get AutoFax Service Control Infomation 
------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetAutoFaxErrorReport]
	
	@process_from varchar(255) = '1900-01-01 00:00:00' ,
	@process_to varchar(255)  =  '2078-01-01 00:00:00' ,
	@logon_user varchar(255) = null

as

	SET NOCOUNT ON

	declare @process_from_d datetime
	declare @process_to_d datetime
	

	select  @process_from_d = convert( datetime,  nullif( @process_from , '') )
	select  @process_to_d = convert( datetime, nullif(  @process_to, '' ) ) + 1
	select @logon_user = nullif( @logon_user , '' )
	
	if @process_from_d is null 
		begin
			select @process_from_d = convert(datetime , '1900-01-01 00:00:00' )
		end

	if @process_to_d is null 
		begin
			select @process_to_d = convert(datetime , '2078-01-01 00:00:00'  )
		end


	if @logon_user is null 
		select 
			control_ID ,
			last_updated_by	,		
			last_updated_on ,
			last_error_number ,
			last_error_source ,
			error_message 
		from autofaxsyserror
		where process_date between @process_from_d and @process_to_d
	else
		select 
			control_ID ,
			last_updated_by	,		
			last_updated_on ,
			last_error_number ,
			last_error_source ,
			error_message 
		from autofaxsyserror
		where process_date between @process_from_d and @process_to_d
			and last_updated_by = @logon_user

	SET NOCOUNT Off





GO
