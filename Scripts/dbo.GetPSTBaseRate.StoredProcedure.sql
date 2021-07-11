USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPSTBaseRate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetPSTBaseRate
PURPOSE: To retrieve the basic PST rate
AUTHOR: Don Kirkby
DATE CREATED: May 14 1999
CALLED BY: Interim Bill
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetPSTBaseRate]
AS
	SELECT 	tax_rate
	  FROM	tax_rate
	 WHERE	tax_type = 'PST'
	   AND	GETDATE() BETWEEN valid_from AND valid_to










GO
