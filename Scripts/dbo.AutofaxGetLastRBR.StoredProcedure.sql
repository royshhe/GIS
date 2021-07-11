USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutofaxGetLastRBR]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





----------------------------------------------------------------------------------------------------------------------------------------------------------
-----  Programmer :   Jack Jian
-----  Date :              Apr 06, 2001
-----  Details:            if @LastClosedFlag = 0 or is missing, return the current RBR date
-----                          if @LastClosedFlag = 1, return the last RBR date closed 
----------------------------------------------------------------------------------------------------------------------------------------------------------
 


CREATE PROCEDURE [dbo].[AutofaxGetLastRBR]
	@last_closed_flag Char(1) = '0' ,
	@rbr_date varchar(255) output
AS


	SELECT	@last_closed_flag = ISNULL(NULLIF( @last_closed_flag ,''), '0')


	SELECT @rbr_date = Max(RBR_Date) 
	FROM	RBR_Date
	WHERE	( @last_closed_flag = '0'
		   OR
		( @last_closed_flag IS NOT NULL
		 AND
		 Budget_Close_Datetime IS NOT NULL))



GO
