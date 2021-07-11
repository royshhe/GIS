USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdOptExtraLastUpdated]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PROCEDURE NAME: UpdateOptExtra
PURPOSE: To update a record in the Optional_Extra table
MOD HISTORY:
Name    Date        	Comments
*/
CREATE PROCEDURE [dbo].[UpdOptExtraLastUpdated]
	@OptionalExtraID	VarChar(10),
	@LastUpdatedBy	VarChar(20)
AS
	Declare	@nOptionalExtraID SmallInt

	Select	@nOptionalExtraID = CONVERT(SmallInt, NULLIF(@OptionalExtraID, ''))

	UPDATE	Optional_Extra
		
	SET	Last_Updated_By = @LastUpdatedBy,
		Last_Updated_On = GetDate()

	WHERE	Optional_Extra_ID = @nOptionalExtraID

RETURN @nOptionalExtraID


GO
