USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustLastUpdated]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*  PURPOSE:		To retrieve the last update date for the given Customer Id.
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustLastUpdated]
	@CustomerId VarChar(10)
AS
	DECLARE	@iCustomerId Integer
	SELECT @iCustomerId = CONVERT(Integer, NULLIF(@CustomerId, ''))

	SELECT	
			Customer_ID,
			CONVERT(VarChar, Last_Changed_On, 113) Last_Changed_On
	
	FROM		Customer

	WHERE	Customer_Id = @iCustomerId
	
RETURN @@ROWCOUNT




GO
