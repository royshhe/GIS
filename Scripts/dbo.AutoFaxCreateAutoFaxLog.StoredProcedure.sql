USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCreateAutoFaxLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------        Programmer :  Jack Jian
------- 	  Date :             Apr 06, 2001
-------        Details:           create Autofax Log
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxCreateAutoFaxLog]
	@log_ID int ,
	@fax_control_id int ,
	@contract_number int ,
	@contract_rbr_date varchar(255) ,
	@try_times int = 3 ,
	@fax_status_code varchar(255) ,
	@recieve_fax_no varchar(30) ,
	@add_error_msg varchar(200) ,
	@last_updated_by varchar(255)

as

	insert into autofaxlog 
		(message_ID ,
		process_date ,
		fax_control_id ,
		contract_number ,
		contract_rbr_date ,
		try_times ,
		fax_status_code ,
		recieve_fax_no ,
		add_error_msg ,
		last_updated_by ,
		last_updated_on )
	values 
		(@log_ID ,
		getdate() ,
		nullif(@fax_control_id , 0) ,
		nullif(@contract_number , 0 ) ,
		convert(datetime , nullif(@contract_rbr_date,'')) ,
		nullif(@try_times , 0 ) ,
		nullif(@fax_status_code , '') ,
		nullif(@recieve_fax_no , '') ,
		nullif( @add_error_msg , '') ,
		@last_updated_by ,
		getdate())
		









GO
