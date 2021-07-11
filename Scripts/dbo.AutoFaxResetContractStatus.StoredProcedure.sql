USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxResetContractStatus]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              May 09, 2001
--  Details: 	 reset fax status
----------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[AutoFaxResetContractStatus]

	@control_id int ,
	@process_status int ,
	@user_name varchar(255)

as

 	declare @contract_number int
	select @contract_number = contract_number from autofaxcontract where control_id = @control_id

	update autofaxcontract  
	set  
 	      process_status = @process_status ,
	      try_times = 0 ,
	      contract_status = ( select status from contract con where con.contract_number = @contract_number ) ,
	      copy_sequence = ( select max(Print_Seq) from Contract_Print cp where cp.Contract_Number = @contract_number ) ,
	      process_date = getdate() ,	
	      last_updated_by = @user_name ,
	      last_updated_on = getdate()
	where control_id = @control_id

GO
