USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetMsgList]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








-----------------------------------------------------------------------------------------------------
-----    Programmer:   Jack Jian
-----    Date:              Apr 27, 2001
----     Details:	     Update status of autofaxcontract table
-----------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetMsgList]

	@message_type int

as

	select message_number ,  message_short
	from autofaxmsg
	where message_type = @message_type
	order by message_number



GO
