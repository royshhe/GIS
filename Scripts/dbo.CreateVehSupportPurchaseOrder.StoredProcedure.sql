USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehSupportPurchaseOrder]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehSupportPurchaseOrder    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportPurchaseOrder    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportPurchaseOrder    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportPurchaseOrder    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Support_Purchase_Order table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehSupportPurchaseOrder]	
	@Sequence	VarChar(10),
	@PONumber	VarChar(15),
	@Amount		VarChar(10),
	@GST		VarChar(10),
	@PST		VarChar(10),
	@Description	VarChar(255)
AS
	INSERT INTO Vehicle_Support_Purchase_Order
		(	
			Vehicle_Support_Incident_Seq,
			PO_Number,
			Amount,
			GST,
			PST,
			Description
		)
	VALUES
		(
			CONVERT(Int, NULLIF(@Sequence, '')),
			NULLIF(@PONumber, ''),
			CONVERT(Decimal(9, 2), NULLIF(@Amount, '')),
			CONVERT(Decimal(9, 2), NULLIF(@GST, '')),
			CONVERT(Decimal(9, 2), NULLIF(@PST, '')),
			NULLIF(@Description, '')
		)
	RETURN @@RowCount














GO
