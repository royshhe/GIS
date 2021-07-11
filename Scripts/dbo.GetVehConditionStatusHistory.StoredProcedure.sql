USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehConditionStatusHistory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehConditionStatusHistory    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehConditionStatusHistory    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehConditionStatusHistory    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehConditionStatusHistory    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehConditionStatusHistory]
	@UnitNumber			VarChar(10),
	@CategoryVehConditionStatus	VarChar(25)
AS
	SELECT	L.Value,
		CONVERT(VarChar, CH.Effective_On, 111),
		CONVERT(VarChar, CH.Effective_On, 108)
	FROM	Condition_History CH,
		Lookup_Table L
	WHERE	CH.Unit_Number	= CONVERT(Int, @UnitNumber)
	AND	L.Category	= @CategoryVehConditionStatus
	AND	L.Code		= CH.Condition_Status
	Order By
		CH.Effective_On Desc,
		L.Value	
RETURN 1












GO
