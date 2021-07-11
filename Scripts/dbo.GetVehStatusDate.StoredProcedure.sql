USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehStatusDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehStatusDate]
	@UnitNum	Varchar(10),
	@StatusCode 	Char(1)
AS
	Set RowCount 1

	Declare	@nUnitNum Integer
	Select		@nUnitNum = Convert(Int, NULLIF(@UnitNum, ""))

	SELECT 	CONVERT(VarChar, Effective_On, 111)

	FROM		Vehicle_History
	WHERE	Unit_Number = @nUnitNum
	AND		Vehicle_Status <> @StatusCode
	ORDER BY	Effective_On Desc

	RETURN @@ROWCOUNT














GO
