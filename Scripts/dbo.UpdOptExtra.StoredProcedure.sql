USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdOptExtra]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.UpdOptExtra    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.UpdOptExtra    Script Date: 2/16/99 2:05:43 PM ******/
/*
PROCEDURE NAME: UpdateOptExtra
PURPOSE: To update a record in the Optional_Extra table
AUTHOR: ?
DATE CREATED: ?
CALLED BY: OptExtra
MOD HISTORY:
Name    Date        	Comments
Don K	Feb 8 1999 	Expanded @OptionalExtra to 35
NP	Oct 27 1999 	Moved data conversion code out of the where clause.
NP	Jan/12/2000 	Add audit info
*/
CREATE PROCEDURE [dbo].[UpdOptExtra]
	@OptionalExtraID	VarChar(10),
	@OptionalExtra		VarChar(35),
	@Type			VarChar(20),
	@MaximumQuantity	VarChar(10),
	@UnitRequired char(1),
	@LastUpdatedBy	VarChar(20)
AS
	Declare	@nOptionalExtraID SmallInt

	Select	@nOptionalExtraID = CONVERT(SmallInt, NULLIF(@OptionalExtraID, ''))

	UPDATE	Optional_Extra
		
	SET	Optional_Extra = @OptionalExtra,
		Maximum_Quantity = CONVERT(SmallInt, @MaximumQuantity),
		Unit_Required=convert(bit,@UnitRequired),
		Type = @Type,
		Last_Updated_By = @LastUpdatedBy,
		Last_Updated_On = GetDate()

	WHERE	Optional_Extra_ID = @nOptionalExtraID

RETURN @nOptionalExtraID


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
