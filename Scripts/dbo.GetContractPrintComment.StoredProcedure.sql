USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetContractPrintComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetContractPrintComment    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetContractPrintComment    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetContractPrintComment    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetContractPrintComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of contract print  comments  for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetContractPrintComment]	--1634708, 'Standard Print Comment' 
	@ContractNumber	VarChar(10),
	@Category	VarChar(25)
AS
	/* 3/09/99 - cpy bug fix - return print comment id twice */

	SELECT	Standard_Print_Comment_ID, Standard_Print_Comment_ID
	FROM	Contract_Print_Comment CPC
	WHERE	CPC.Contract_Number	= CONVERT(Int, @ContractNumber)
	Union
	Select 26  as Standard_Print_Comment_ID, 26 as Standard_Print_Comment_ID
	from contract where pick_up_location_id in 
	(
			SELECT   Location_ID 
		FROM  Location
		WHERE (Nearby_Airport_location =16)

	) and @Category='Standard Print Comment' 
	And Contract_number=   CONVERT(Int, @ContractNumber)
	And Status in ('OP', 'CO')
RETURN 1
GO
