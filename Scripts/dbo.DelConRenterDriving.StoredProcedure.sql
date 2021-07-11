USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelConRenterDriving]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelConRenterDriving    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.DelConRenterDriving    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelConRenterDriving    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelConRenterDriving    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Renter_Driver_Licence table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[DelConRenterDriving]
	@ContractNumber	VarChar(10)
AS
	/* 3/12/99 - cpy bug fix - apply nullif */
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber,''))

	DELETE	Renter_Driver_Licence
	
	WHERE	Contract_Number = @iCtrctNum
RETURN 1















GO
