USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehStatusHistory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehStatusHistory    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehStatusHistory    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehStatusHistory    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehStatusHistory    Script Date: 11/23/98 3:55:34 PM ******/
/*
NP - Aug 09 1999 - Added Effective_On time.
*/
CREATE PROCEDURE [dbo].[GetVehStatusHistory]
	@UnitNumber		VarChar(10),
	@CategoryVehicleStatus	VarChar(25)
AS
	SELECT	L.Value,
			CONVERT(VarChar, VH.Effective_On, 111),
			CONVERT(VarChar, VH.Effective_On, 108)

	FROM		Vehicle_History VH,
			Lookup_Table L

	WHERE	VH.Unit_Number	= CONVERT(Int, @UnitNumber)
	AND		L.Category	= @CategoryVehicleStatus
	AND		L.Code		= VH.Vehicle_Status

	Order By	
			Vh.Effective_On Desc,
			L.Value
	
RETURN 1













GO
