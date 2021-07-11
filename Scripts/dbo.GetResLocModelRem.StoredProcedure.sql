USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResLocModelRem]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResLocModelRem    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocModelRem    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocModelRem    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocModelRem    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResLocModelRem]
	@VehClassCode Varchar(1)
AS
	IF @VehClassCode = ""	SELECT @VehClassCode = NULL
	SELECT	Distinct B.Model_Name
	FROM	Vehicle_Model_Year B,
		Vehicle_Class_Vehicle_Model_Yr A
	WHERE	A.Vehicle_Model_ID = B.Vehicle_Model_ID
	AND	A.Vehicle_Class_Code = @VehClassCode
	AND	B.Foreign_Model_Only = 0
	AND 	(B.Model_Year = datepart(yyyy,getdate())
		or B.Model_Year = datepart(yyyy,getdate())-1
		or B.Model_Year = datepart(yyyy,getdate())+1)
	ORDER BY B.Model_Name
	RETURN @@ROWCOUNT
GO
