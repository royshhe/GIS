USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelVehSupportPurchaseOrder]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelVehSupportPurchaseOrder    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.DelVehSupportPurchaseOrder    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelVehSupportPurchaseOrder    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelVehSupportPurchaseOrder    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Vehicle_Support_Purchase_Order table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DelVehSupportPurchaseOrder]	
	@Sequence	VarChar(10),
	@OldPONumber	VarChar(15)
AS
	/* 10/10/99 - do type conversion and nullif outside of sql */

DECLARE	@iSequence Int

	SELECT	@iSequence = CONVERT(Int, NULLIF(@Sequence, '')),
		@OldPONumber = NULLIF(@OldPONumber, '')

	DELETE	Vehicle_Support_Purchase_Order
		
	WHERE	Vehicle_Support_Incident_Seq = @iSequence
	AND	PO_Number = @OldPONumber
	RETURN @@RowCount















GO
