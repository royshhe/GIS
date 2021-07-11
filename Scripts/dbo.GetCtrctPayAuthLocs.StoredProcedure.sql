USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPayAuthLocs]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*  PURPOSE:		To retrieve a list of locations where payments were collected or authorized for the given contract.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPayAuthLocs]
	@CtrctNum	VarChar(10)
AS
DECLARE	@iContractNum Int

	SELECT	@iContractNum = Convert(Int, NULLIF(@CtrctNum,''))

	/* 3/1/99 - cpy created - return all locations involved in payments
				 or auths for a contract */

	SELECT	L.Location, CPI.Collected_At_Location_Id
	FROM	Location L,
		Contract_Payment_Item CPI
	WHERE	CPI.Contract_Number = @iContractNum
	AND	CPI.Collected_At_Location_Id = L.Location_Id

	UNION

	SELECT	L.Location, CCA.Authorized_At_Location_ID
	FROM	Location L,
		Credit_Card_Authorization CCA
	WHERE	CCA.Contract_Number = @iContractNum
	AND	CCA.Authorized_At_Location_ID = L.Location_Id
	ORDER BY 1
	
	RETURN @@ROWCOUNT
















GO
