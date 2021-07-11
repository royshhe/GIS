USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctLastUpdated]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*  PURPOSE:		To retrieve the last update date for the given contract number
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctLastUpdated]
	@CtrctNum VarChar(10)
AS

	DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum, ''))

	SELECT	
			Contract_Number,
			CONVERT(VarChar, Last_Update_On, 113) Last_Update_On
	
	FROM		Contract 

	WHERE	Contract_Number = @iCtrctNum
	
RETURN @@ROWCOUNT






GO
