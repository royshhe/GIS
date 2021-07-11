USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdOptExtraGLAccount]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Jul 2003
--	Details		Update Optional Extra GL Account Number
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[UpdOptExtraGLAccount]
	@OptionalExtraID	VarChar(10),
	@VehicleType		VarChar(10),
	@GLAccount		VarChar(20)
AS
	Declare	@nOptionalExtraID SmallInt

	Select	@nOptionalExtraID = CONVERT(SmallInt, NULLIF(@OptionalExtraID, ''))

	UPDATE	Optional_Extra_GL
		
	SET	GL_Revenue_Account = @GLAccount

	WHERE	Optional_Extra_ID = @nOptionalExtraID
	and 	Vehicle_Type_ID = @VehicleType

RETURN @nOptionalExtraID
GO
