USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOriginalDropOffInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctOriginalDropOffInfo    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOriginalDropOffInfo    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOriginalDropOffInfo    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOriginalDropOffInfo    Script Date: 11/23/98 3:55:33 PM ******/
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve the drop off information for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctOriginalDropOffInfo]
	@ContractNum Varchar(10)
AS
	DECLARE	@nContractNum Integer
	SELECT	@nContractNum = Convert(Int, NULLIF(@ContractNum,""))

	SELECT	Drop_Off_Location_ID,
		CONVERT(VarChar, Drop_Off_On, 111) Drop_Off_Date,
		CONVERT(VarChar, Drop_Off_On, 108) Drop_Off_Time,
		Last_Update_By,
		Last_Update_On
	FROM	Contract
	WHERE	Contract_Number = @nContractNum
	RETURN @@ROWCOUNT















GO
