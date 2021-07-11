USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehSupportPurchaseOrder]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





/****** Object:  Stored Procedure dbo.UpdVehSupportPurchaseOrder    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehSupportPurchaseOrder    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehSupportPurchaseOrder    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehSupportPurchaseOrder    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Vehicle_Support_Purchase_Order table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdVehSupportPurchaseOrder]	
	@Sequence	VarChar(10),
	@OldPONumber	VarChar(15),
	@PONumber	VarChar(15),
	@Amount		VarChar(10),
	@GST		VarChar(10),
	@PST		VarChar(10),
	@Description	VarChar(255)
AS
	Declare @nSequence Int

	Select @nSequence = CONVERT(Int, NULLIF(@Sequence, ''))
	Select @OldPONumber = NULLIF(@OldPONumber, '')

	UPDATE	Vehicle_Support_Purchase_Order
		
	SET	PO_Number = NULLIF(@PONumber, ''),
		Amount = CONVERT(Decimal(9, 2), NULLIF(@Amount, '')),
		GST = CONVERT(Decimal(9, 2), NULLIF(@GST, '')),
		PST = CONVERT(Decimal(9, 2), NULLIF(@PST, '')),
		Description = NULLIF(@Description, '')

	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	AND		PO_Number = @OldPONumber

	RETURN @@RowCount










GO
