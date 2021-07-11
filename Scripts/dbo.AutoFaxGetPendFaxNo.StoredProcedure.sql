USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetPendFaxNo]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 18, 2001
--  Details: 	 get pending faxs list to fax
--  		 conditions: 1- not so many try times
--			      2- not recieved response_id ( response_id = 0 ) or 
--				   recieved response_id but fax server did not recieced the attachments infomation  (now process status = )
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxGetPendFaxNo]

	@process_status int ,  --  enmAttachMissing 500001
	@max_send_try_times int = 3 ,
	@control_status bit = 0

as

	select distinct reciever_fax_no
	from autofax
	
	where  ( response_id = 0  or process_status = @process_status )
		and send_try_times < @max_send_try_times
		and control_status = @control_status




GO
