USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehModelName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehModelName    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.GetVehModelName    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehModelName    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehModelName    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehModelName]
AS
	SELECT	Distinct Model_Name
	FROM	Vehicle_Model_Year
	ORDER BY
		Model_Name	
RETURN 1












GO
