USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptVehModelYear]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetRptVehModelYear
PURPOSE: To retrieve a list of vehicle years for one or all models
AUTHOR: Don Kirkby
DATE CREATED: Jun 29, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRptVehModelYear]
	@ModelName	varchar(25)
AS
	SELECT	ISNULL(CAST(model_year AS varchar), 'Blank')
	  FROM	vehicle_model_year
	 WHERE	(  model_name = @ModelName
	    	OR @ModelName = ''
		)
	   AND	foreign_model_only = 0
	 GROUP
	    BY	model_year
	 ORDER
	    BY	model_year DESC
















GO
