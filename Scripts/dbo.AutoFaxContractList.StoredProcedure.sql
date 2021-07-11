USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxContractList]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 10, 2001
--  Details: 	 get pending contracts list to fax
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxContractList] 

	@process_status int = 200000  --  Record is created! NO Action!

as

	select 
		afc.control_ID  ,
		afc.Contract_number ,
		afc.contract_rbr_date   ,
	 	con.status  as contract_status

	from autofaxcontract  afc
	join contract con
		on afc.contract_number = con.contract_number

	where afc.process_status = @process_status

	order by afc.contract_rbr_date




GO
