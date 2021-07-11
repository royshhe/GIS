USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllReimbursementReasons]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: 	To retrieve a list of reimbursement reasons.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllReimbursementReasons]

AS

SELECT
	Reason
FROM
	Reimbursement_Reason
ORDER BY
	Reason
	
RETURN 1










GO
