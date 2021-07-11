USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehModelYear]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehModelYear]
	@ModelName	VarChar(25)
AS
	Select		@ModelName = NULLIF(@ModelName, '')

	SELECT	Model_year
	FROM		Vehicle_Model_Year
	WHERE	Model_Name	= @ModelName
	ORDER BY	Model_Year DESC
	

RETURN 1
















GO
