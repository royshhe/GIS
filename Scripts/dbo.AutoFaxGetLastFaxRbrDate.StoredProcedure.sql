USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetLastFaxRbrDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              Apr 06, 2001
-----  Details:            get last faxed rbr date
----------------------------------------------------------------------------------------------------------------------------------------------------------
 


CREATE PROCEDURE [dbo].[AutoFaxGetLastFaxRbrDate]
	@process_status int  ,
	@rbr_date varchar(255) output
AS


	SELECT @rbr_date = Max(RBR_Date) 
	FROM	autofaxprocess
	WHERE process_status = @process_status




GO
