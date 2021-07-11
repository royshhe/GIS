USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNumOfVehOnContract]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetNumOfVehOnContract    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetNumOfVehOnContract    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetNumOfVehOnContract    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetNumOfVehOnContract    Script Date: 11/23/98 3:55:33 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetNumOfVehOnContract]
	@ContractNumber 	VarChar(10)
AS
	DECLARE	@nContractNumber Integer
	SELECT	@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber , ''))

	SELECT	Count(*)
	
	FROM	Vehicle_On_Contract
	WHERE	Contract_Number = @nContractNumber
	
	
RETURN @@ROWCOUNT













GO
