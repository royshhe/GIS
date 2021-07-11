USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetAutoFaxLogReport]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              May 04, 2001
-----  Details:            Get Log Report
----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE    [dbo].[AutoFaxGetAutoFaxLogReport]

	@process_status int ,
	@process_from varchar(255)  ='' ,
	@process_to varchar(255)  ='' ,
	@rbr_from varchar(255) ='' ,
	@rbr_to varchar(255)  ='' ,
	@user_name varchar(255) ='' ,
	@contract_number int =0 ,
	@fax_number varchar(255) ='' 

 AS

	declare @process_from_d datetime
	declare @process_to_d datetime
	declare @rbr_from_d datetime
	declare @rbr_to_d datetime
	
	select  @process_from_d = convert( datetime,  nullif( @process_from , '') )
	select  @process_to_d = convert( datetime, nullif(  @process_to, '' ) )
	select  @rbr_from_d = convert( datetime,  nullif( @rbr_from , '') )
	select  @rbr_to_d = convert( datetime, nullif(  @rbr_to ,  '' ) )

	if @process_from_d is null 
		begin
			select @process_from_d = convert(datetime , '1900-01-01 00:00:00' )
		end
  
	if @process_to_d is null 
		begin
			select @process_to_d = convert(datetime , '2078-01-01 00:00:00'  )
		end
	else
		begin
			select @process_to_d = @process_to_d + 1
		end
	
	if not @rbr_to_d is null
		begin
			select @rbr_to_d = @rbr_to_d + 1
		end			

	select	afl.control_ID,  
		afl.process_date ,               
		afl.contract_number ,
		afl.contract_rbr_date ,          
		afl.try_times   ,
		afl.fax_status_code ,
		afl.recieve_fax_no  ,               
		afm.message_description     ,     
		afl.last_updated_by      
	from autofaxlog afl
	join  autofaxmsg afm
		on afl.message_id = afm.message_number
	where afl.message_ID = @process_status
		and afl.process_date between @process_from_d and @process_to_d
	 	and (( afl.contract_rbr_date between @rbr_from_d and @rbr_to_d )  or @rbr_from_d is null or @rbr_to_d is null )
		and ( afl.last_updated_by = @user_name or @user_name = '' )
		and ( afl.recieve_fax_no = @fax_number  or @fax_number = '' )
		and ( afl.contract_number = @contract_number or @contract_number = 0 )
	order by control_ID





GO
