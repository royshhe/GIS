USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintCommentLong]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctPrintCommentLong    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrintCommentLong    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		return list of standard print comments  for this contract (long desc)
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintCommentLong]-- 1741011
	@ContractNumber	VarChar(10)
AS
	/* 02/15/99 - cpy - return list of standard print comments
			    for this contract (long desc) */
			    
	Declare @FromYVRComment Varchar(300)
	Select @FromYVRComment= LT.Value from Lookup_Table LT where LT.Code=26   AND	LT.Category		= "Standard Print Comment"
	
	SELECT	LT.Value
	FROM	Contract_Print_Comment CPC,
		Lookup_Table LT
	WHERE	CPC.Standard_Print_Comment_ID = CONVERT(SmallInt, LT.Code)
	AND	LT.Category		= "Standard Print Comment"
	AND	CPC.Contract_Number	= CONVERT(Int, @ContractNumber)
	Union
	Select @FromYVRComment
	from contract where pick_up_location_id in (
						SELECT   Location_ID 
							FROM  Location
							WHERE (Nearby_Airport_location =16)

							)  
	And Contract_Number	= CONVERT(Int, @ContractNumber)
	
	RETURN @@ROWCOUNT













GO
