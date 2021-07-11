USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContractInternalComment]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateContractInternalComment    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractInternalComment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractInternalComment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractInternalComment    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Contract_Internal_Comment table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateContractInternalComment]
	@ContractNumber	VarChar(10),
	@Comments	VarChar(255),
	@User		VarChar(20)
AS
	INSERT INTO Contract_Internal_Comment
		(
		Contract_Number,
		Logged_On,
		Logged_By,
		Comments
		)
	VALUES
		(
		CONVERT(Int, @ContractNumber),
		GetDate(),
		@User,
		@Comments
		)
RETURN 1













GO
