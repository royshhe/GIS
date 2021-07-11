USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCtrctPrintRecord]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateCtrctPrintRecord    Script Date: 2/18/99 12:11:41 PM ******/
CREATE PROCEDURE [dbo].[CreateCtrctPrintRecord]
	@ContractNum Varchar(10),
	@CopyNum Varchar(5),
	@PrintedBy Varchar(20),
	@PrintedOn Varchar(24)
AS
DECLARE @iContractNum Int
DECLARE @iCopyNum SmallInt

	/* 2/17/99 - cpy - created
			 - create record of contract print */

	SELECT @iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	-- if no @CopyNum provided, default Copy Number to max(copynum) + 1

	SELECT @iCopyNum = Convert(SmallInt, NULLIF(@CopyNum,''))
	-- get the current max sequence number + 1
	IF @iCopyNum IS NULL
		SELECT 	@iCopyNum = (Max(Print_Seq) + 1)
		FROM	Contract_Print
		WHERE	Contract_Number = @iContractNum

	INSERT INTO Contract_Print
		(Contract_Number,
		 Print_Seq,
		 Printed_By,
		 Printed_On)
	VALUES
		(Convert(Int, NULLIF(@ContractNum,"")),
		 @iCopyNum,
		 NULLIF(@PrintedBy, ""),
		 Convert(Datetime, NULLIF(@PrintedOn,"")))

	RETURN @@ROWCOUNT











GO
