USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptExtraGLAccount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Jul 2003
--	Details		Get Optional Extra GL Account Number
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetOptExtraGLAccount]
	@Optional_Extra_ID VarChar(10)
AS


SELECT	Optional_Extra_ID,
	Vehicle_Type_ID,
	GL_Revenue_Account
	FROM	Optional_Extra_GL
	WHERE	Optional_Extra_ID = CONVERT(SmallInt, @Optional_Extra_ID)
RETURN 1
GO
