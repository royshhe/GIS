USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckForInactiveBillingParty]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PURPOSE: To check whether or not a contract involves any direct bill companies that 
	 have been inactivated; return the names of the inactivated direct bill 
	 companies for a given contract
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 7 2000	Created
*/
CREATE PROCEDURE [dbo].[CheckForInactiveBillingParty] 
	@CtrctNum 	Varchar(11)
AS

DECLARE @iCtrctNum Int 

	SELECT	@iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	SELECT	AM.Address_Name, AM.Customer_Code
	FROM	armaster AM WITH (NOLOCK),
		Contract_Billing_Party CBP
	WHERE	CBP.Contract_Number = @iCtrctNum
	AND	CBP.Customer_Code = AM.Customer_Code
	AND	AM.Address_Type = 0	-- companies only
	AND	AM.Status_Type <> 1	-- not active

	RETURN @@ROWCOUNT





GO
