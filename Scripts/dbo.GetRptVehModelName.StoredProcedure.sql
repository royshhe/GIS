USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptVehModelName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetRptVehModelName
PURPOSE: To retrieve a list of vehicle model names for one or all years
PARAMS:
  ModelYear:	'' will return a complete list of names
AUTHOR: Don Kirkby
DATE CREATED: Jun 29, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptVehModelName]
	@ModelYear	varchar(11)
AS
	DECLARE	@nModelYear Integer
	SELECT	@nModelYear = CAST(NULLIF(@ModelYear, '') AS int)

	SELECT
      DISTINCT	model_name
	  FROM	vehicle_model_year
	 WHERE	(  model_year = @nModelYear
	    	OR @ModelYear = ''
		)
	   AND	foreign_model_only = 0
	 ORDER
	    BY	model_name













GO
