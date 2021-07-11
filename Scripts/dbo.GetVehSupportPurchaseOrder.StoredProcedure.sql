USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehSupportPurchaseOrder]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehSupportPurchaseOrder    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportPurchaseOrder    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportPurchaseOrder    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportPurchaseOrder    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehSupportPurchaseOrder]
	@Sequence Varchar(10)
AS
	Declare	@nSequence Integer
	Select		@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	PO_Number,
		PO_Number,
		Amount,
		GST,
		PST,
		Description
	FROM	Vehicle_Support_Purchase_Order
	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	ORDER BY
		PO_number
	RETURN @@ROWCOUNT













GO
