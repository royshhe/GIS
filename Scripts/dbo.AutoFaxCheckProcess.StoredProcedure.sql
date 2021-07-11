USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCheckProcess]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              Apr 09, 2001
-----  Details:            Check the process before
----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[AutoFaxCheckProcess]

	@before_date varchar(255) = 'Jan 01 2001' ,
	@check_status int  = 200000 ,            -- 200000  is "Record created! NO Action!"
	@check_return bit output

as
	declare @before_date_d  datetime
	select @before_date_d = convert( datetime, @before_date)

	if exists (
  			select * 
			from autofaxcontract 
			where  contract_rbr_date <= @before_date_d and
			            process_status = @check_status  
		)
		set @check_return = 1
	else
		set @check_return = 0



GO
