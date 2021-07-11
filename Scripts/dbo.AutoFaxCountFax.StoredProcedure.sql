USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCountFax]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              May 29, 2001
--  Details: 	 get statistics data for fax records
----------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxCountFax]

	@process_status int = 0 ,
	@count int output
as
	

	select @count = count(*) 
	from autofax    
	where process_status = @process_status  or @process_status = 0


	



GO
