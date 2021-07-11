USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetFaxListByID]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              May 08, 2001
-----  Details:            Get Fax details list by response id
----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[AutoFaxGetFaxListByID]

	@response_id int ,
	@fax_number varchar(255) = '' ,
	@reciever_id varchar(255)

as
	select 
		atf.response_id as 'Response ID' ,
		atf.reciever_fax_no as 'Fax Number' ,
		atf.contract_number as 'Con. No.' ,
		atf.contract_rbr_date as ' RBR Date ' ,
		atf.contract_status as 'Con. Status' ,
		atft.type_description as 'Fax Type' ,
		atf.pcl_file_name as 'File name' ,
		atf.send_device_name as 'Device Name' ,
		atf.last_updated_by as 'Last Updated By' ,
		atf.last_updated_on as 'Last Updated On'
	from autofax atf
	join autofaxtype atft
		on atft.type_ID = atf.fax_type
	where atf.response_id = @response_id
		and ( atf.reciever_fax_no = @fax_number or @fax_number = '' )
		and atf.reciever_id = @reciever_id
	order by atf.contract_rbr_date , atf.contract_number






GO
