USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOptionalExtraItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[DeleteOptionalExtraItem]
	@UnitNumber Varchar(12),
	@OptionalExtraType Varchar(20)
AS
	UPDATE	Optional_Extra_Inventory
	SET	Deleted_Flag = 1
	WHERE	Unit_Number = @UnitNumber and
		    Optional_Extra_Type = @OptionalExtraType
	
RETURN 1
GO
