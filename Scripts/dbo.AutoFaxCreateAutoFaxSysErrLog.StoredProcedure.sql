USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCreateAutoFaxSysErrLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------        Programmer :  Jack Jian
------- 	  Date :             Apr 06, 2001
-------        Details:           create Autofax Syetm Error Log
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxCreateAutoFaxSysErrLog]
	@last_error_number int ,
	@last_error_source varchar(255) ,
	@error_message varchar(255) ,
	@last_updated_by varchar(255)

as

	insert into AutoFaxSysError 
		( process_date ,
		last_error_number ,
		last_error_source ,
		error_message ,
		last_updated_by ,
		last_updated_on )
	values 
		( getdate() ,
		@last_error_number ,
		nullif( @last_error_source , '') ,
		nullif( @error_message , '' ) ,
		nullif( @last_updated_by , '' ) ,
		getdate() )
		



GO
