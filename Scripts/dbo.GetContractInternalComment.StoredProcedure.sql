USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetContractInternalComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetContractInternalComment    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetContractInternalComment    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetContractInternalComment    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetContractInternalComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the contract internal comment  for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
-- Don K - Mar 31 1999 - Dropped seconds from logged_on
CREATE PROCEDURE [dbo].[GetContractInternalComment]
	@ContractNumber	VarChar(10)
AS
	/* 7/13/99 - convert Logged_On to string with millisecs */

	SELECT	Comments,
			Logged_By,
			Convert(Varchar(30), Logged_On, 113)
	FROM	Contract_Internal_Comment
	WHERE	Contract_Number	= CONVERT(Int, @ContractNumber)
RETURN 1
















GO
