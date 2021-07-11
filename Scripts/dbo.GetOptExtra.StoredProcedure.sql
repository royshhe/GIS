USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptExtra]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetOptExtra    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtra    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtra    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtra    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOptExtra] 
	@OptionalExtraID	VarChar(10)
AS
	SELECT	Optional_Extra_ID,
		Optional_Extra,
		Type,
		Maximum_Quantity,
		convert(char(1),Unit_Required)
	FROM	Optional_Extra
	WHERE	Optional_Extra_ID	= CONVERT(SmallInt, @OptionalExtraID)
	AND	Delete_Flag		= 0
RETURN 1


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
