USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetQueryResponseIDs]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------        Programmer :  Jack Jian
------- 	  Date :             Apr 30,  2001
-------        Details:           create Autofax Syetm Error Log
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetQueryResponseIDs]

	@max_retry_times int = 5 ,
	@process_status_ok int = 499999

as


	select 
		distinct(afx.response_id) , afx.reciever_fax_no 
	from 
		autofax afx
	join autofaxmsg afm
		on afx.process_status = afm.message_number
		and afm.query_flag = 1
	where 
		afx.response_id <> 0
		and afx.send_try_times < @max_retry_times
		and process_status <> @process_status_ok

	order by afx.response_id





GO
