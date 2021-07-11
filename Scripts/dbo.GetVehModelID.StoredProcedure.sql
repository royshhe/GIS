USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehModelID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehModelID    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetVehModelID    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehModelID    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehModelID    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehModelID]
	@ModelName	VarChar(25),
	@ModelYear	VarChar(10)
AS
	SELECT	Distinct Vehicle_Model_ID
	FROM	Vehicle_Model_Year
	WHERE	Model_Name	= @ModelName
	AND	Model_Year	= CONVERT(Int, @ModelYear)
	
RETURN 1














GO
