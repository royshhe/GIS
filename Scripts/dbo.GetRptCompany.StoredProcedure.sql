USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptCompany]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRptCompany    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRptCompany    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptCompany    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptCompany
PURPOSE: To retrieve a list of owning companies
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
Don K	Feb 15 1999 Added ForeignOnly param
Don K	Aug 11 1999 Added LocName param
*/
CREATE PROCEDURE [dbo].[GetRptCompany]
	@ForeignOnly varchar(1),
	@ResnetFlag varchar(1),
	@LocName varchar(25)
AS
	DECLARE	@bResnet bit
	IF @ResnetFlag != 'E'
		SELECT	@bResnet = CAST(@ResnetFlag AS bit)

	SELECT	name,
		owning_company_id
	  FROM	owning_company
	 WHERE	delete_flag = 0
	   AND	owning_company_id IN
		(
		SELECT	owning_company_id
		  FROM	location
		 WHERE	(  resnet = @bResnet
			OR @ResnetFlag = 'E'
			)
		   AND	delete_flag = 0
		)
	   AND	(  owning_company_id !=
		   (
		   SELECT CONVERT(smallint, code)
		     FROM lookup_table
		    WHERE category = 'BudgetBC Company'
		   )
		OR @ForeignOnly = '0'
		)
	   AND	(  owning_company_id IN
			(
			SELECT	owning_company_id
			  FROM	location
			 WHERE	location = @LocName
			)
		OR @LocName = ''
		)
	 ORDER
	    BY	name














GO
