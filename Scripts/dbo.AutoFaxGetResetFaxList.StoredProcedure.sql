USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetResetFaxList]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              May 07, 2001
-----  Details:            Get Fax list to reset
----------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE  [dbo].[AutoFaxGetResetFaxList]

	@process_from varchar(255) = '' ,
	@process_to varchar(255) = ''

as
	declare @Process_from_d datetime
	declare @Process_to_d datetime
	
	select 	@Process_from_d = convert( datetime , nullif( @Process_from , '' ) )
	select 	@Process_to_d = convert( datetime , nullif( @Process_to , '' ) )

	if @Process_from_d is null
   		begin
 			select @Process_from_d = convert( datetime , '1900-01-01' )
		end

	if @Process_to_d is null
   		begin
 			select @Process_to_d = convert( datetime , '2078-01-01' )
		end
	else
   		begin
 			select @Process_to_d = convert( datetime , @Process_to ) + 1
		end

	select 
		distinct(atf.response_id)  as 'Response ID' ,
		atf.create_date as 'Create Date'  ,
		atf.reciever_fax_no  as 'Fax Number' ,
		msg.message_short as 'Status' ,
		atf.reciever_id as 'Reciever ID' ,
		atf.reciever_name as 'Reciever Name' ,
 		( select count(*) from autofax where atf.response_id = response_id and atf.reciever_fax_no = reciever_fax_no and  reciever_id = atf.reciever_id ) as Attachments

	from autofax atf
	join autofaxmsg msg
		on atf.process_status = msg.message_number
		
	where atf.last_updated_on between @Process_from_d and @Process_to_d

	order by atf.create_date , atf.reciever_fax_no
		














GO
