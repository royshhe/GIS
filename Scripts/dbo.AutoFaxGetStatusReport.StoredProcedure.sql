USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetStatusReport]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Jun 08, 2001
--  Details: 	 Get the fax status report
------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetStatusReport]
	
	@process_from varchar(255) = '1900-01-01 00:00:00' ,
	@process_to varchar(255)  =  '2078-01-01 00:00:00' 

as

	SET NOCOUNT ON

	declare @process_from_d datetime
	declare @process_to_d datetime

	select  @process_from_d = convert( datetime,  nullif( @process_from , '') )
	select  @process_to_d = convert( datetime, nullif(  @process_to, '' ) ) + 1
	
	if @process_from_d is null 
		begin
			select @process_from_d = convert(datetime , '1900-01-01 00:00:00' )
		end

	if @process_to_d is null 
		begin
			select @process_to_d = convert(datetime , '2078-01-01 00:00:00'  )
		end

	select 
		f.last_updated_on as 'process_time' ,
		left(reciever_fax_no , 15) as 'fax_number' ,
		left(contract_number , 10) as 'contract_number' ,
		f.contract_rbr_date as 'contract_rbr_date' ,
		left(reciever_id , 13) as 'company_id' ,
		left(reciever_name , 20) as 'company_name' ,
		left(m.message_short, 18) as 'status' ,
		left(t.type_description,25) as 'fax_type' 

	 from autofax f
	join autofaxmsg m
		on f.process_Status = m.message_number
	join autofaxtype t
		on f.fax_type = t.type_id

	where f.last_updated_on >= @process_from_d and f.last_updated_on < @process_to_d

	order by  left(reciever_fax_no , 15) , left(contract_number , 10)





GO
