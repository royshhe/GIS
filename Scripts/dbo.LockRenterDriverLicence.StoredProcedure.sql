USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockRenterDriverLicence]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the renter driver's licences for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockRenterDriverLicence]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	renter_driver_licence WITH(UPDLOCK)
	 WHERE	contract_number = @nCtrctNum







GO
