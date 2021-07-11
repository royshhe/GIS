USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctLastUpdated]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To update the last updated on/by fields on a Contract
MOD HISTORY:
Name	Date        	Comments
*/
CREATE PROCEDURE [dbo].[UpdateCtrctLastUpdated] 
	@CtrctNum Varchar(11),
	@UserName Varchar(20)
AS
	SELECT	@CtrctNum = NULLIF(@CtrctNum,''),
		@UserName = NULLIF(@UserName,'')

	UPDATE	Contract
	SET	Last_Update_By = @UserName,
		Last_Update_On = GetDate()
	WHERE	Contract_Number = Convert(Int, @CtrctNum)

	RETURN @@ROWCOUNT


GO
