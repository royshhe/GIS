USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxQueryRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








----------------------------------------------------------------------------------------------------------------------------------------
---   Programmer :      Jack Jian
---   Date:	      Apr 05, 2001
---   Details:	      Query if a certain RBR day has been processed before or not.
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxQueryRBRDate]

	@rbr_date varchar(255) = 'Jan 01 2001' ,
	@rbr_exist int output

as
	declare @rbr_date_d as datetime
	select @rbr_date_d = convert(datetime , @rbr_date)
	
	if exists 
		(select * 
		from autofaxprocess 
		where rbr_date = @rbr_date_d )

		select @rbr_exist = 1
	else 
		select @rbr_exist = 0




GO
