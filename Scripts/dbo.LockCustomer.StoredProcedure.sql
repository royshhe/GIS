USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockCustomer]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the customer record for the given customer id
AUTHOR: Niem Phan
DATE CREATED: Jan 17, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockCustomer]
	@CustomerId varchar(11)
AS

	DECLARE @iCustomerId Integer
	SELECT @iCustomerId = CAST(NULLIF(@CustomerId, '') AS Integer)

	SELECT	COUNT(*)
	  FROM	Customer WITH(UPDLOCK)
	 WHERE	Customer_Id = @iCustomerId




GO
