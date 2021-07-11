USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_GetInvoiceRDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.OM_GetRBRDateTimeForCRTransLog    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.OM_GetRBRDateTimeForCRTransLog    Script Date: 2/16/99 2:05:42 PM ******/
-- Get Transaction Log Time Range by RBR Date
CREATE PROCEDURE [dbo].[ITB_GetInvoiceRDate]
AS
	
	SELECT	RBR_Date,Budget_Start_Datetime, Budget_Close_Datetime
	FROM	RBR_Date
	WHERE	( Budget_Close_Datetime IS NOT NULL) and (Date_ITB_Invoice_Generated is null)

	RETURN @@ROWCOUNT

GO
