USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetResetContractList]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              May 09, 2001
-----  Details:            Get Contract list to reset
----------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE  [dbo].[AutoFaxGetResetContractList]

	@process_from varchar(255) = '' ,
	@process_to varchar(255) = '' ,
	@control_id int = 0

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
		afc.control_ID as 'ControlID' ,
		afc.process_date as 'Process Date' ,
		afc.Contract_number as 'Con. No.' ,
		msg.message_short as Status ,
		afc.contract_rbr_date as 'Rbr Date' ,
		afc.copy_sequence as 'Seq.#.' ,
		aft.type_description as 'Fax Type' ,
		afc.contract_status as 'Status' , 
		afc.try_times as 'Try Times' ,
		afc.last_updated_by as 'Last Updated By' ,
		afc.last_updated_on as 'Last Updated On'

	from autofaxcontract afc
	join autofaxmsg msg
		on afc.process_status = msg.message_number
	join autofaxtype aft
		on aft.type_ID = afc.fax_type
	where afc.process_date between @Process_from_d and @Process_to_d
		and ( afc.control_id = @control_id or @control_id =0 )
	order by afc.Contract_number
		










GO
