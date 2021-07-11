USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOptExtraGLAccount]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Jul 2003
--	Details		Craete Optional Extra GL Account
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[CreateOptExtraGLAccount]
	@OptionalExtraID	VarChar(5),
	@VehicleType		VarChar(10),
	@GLAccount		VarChar(20)
AS
	
	INSERT INTO Optional_Extra_GL
		(
		Optional_Extra_ID,
		Vehicle_Type_ID,
		GL_Revenue_Account
		)
	VALUES
		(
		CONVERT(SmallInt, @OptionalExtraID),
		@VehicleType,
		@GLAccount
		)
RETURN 1
GO
