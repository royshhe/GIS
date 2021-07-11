USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehLastService]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehLastService    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLastService    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLastService    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLastService    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehLastService]
	@UnitNum Varchar(10)
AS
	Declare	@nUnitNum Integer
	Select		@nUnitNum = Convert(Int, NULLIF(@UnitNum, ""))

	SET ROWCOUNT 1
	SELECT 	CONVERT(VarChar, Service_Performed_On, 111),
		Km_Reading,
		CONVERT(VarChar, Service_Performed_On, 108)
	FROM	Vehicle_Service
	WHERE	Unit_Number = @nUnitNum
	ORDER BY Service_Performed_On DESC
	RETURN @@ROWCOUNT













GO
