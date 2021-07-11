USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetConPrintSequence]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------        Programmer :  Jack Jian
------- 	  Date :             Apr 12, 2001
-------        Details:           Get contract print/copy sequence number
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxGetConPrintSequence]

	@contract_number int ,
	@copy_sequence int output

as

	select @copy_sequence = max(Print_Seq)  
	from contract_print 
	where contract_number = @contract_number


GO
