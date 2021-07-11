USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGLReimbursementAccount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetGLReimbursementAccount    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetGLReimbursementAccount    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetGLReimbursementAccount]
	@Reason 	VarChar(255),
	@LocationID	VarChar(10)='0'
AS

Declare @LocatonAcctgSeg VarChar(15)

 SELECT	@LocatonAcctgSeg =	 (	SELECT	DISTINCT Acctg_Segment
					FROM	Location 
					WHERE	Location_ID = convert(smallint, @LocationID)
				) 

If @LocatonAcctgSeg is not null

		SELECT
			Replace(GL_Reimbursement_Account_Code, 'XX', @LocatonAcctgSeg)
		FROM
			Reimbursement_Reason
		WHERE
			Reason = @Reason
Else
		SELECT
			GL_Reimbursement_Account_Code
		FROM
			Reimbursement_Reason
		WHERE
			Reason = @Reason
RETURN 1
GO
