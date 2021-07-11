USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateQIOE]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateQIOE    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateQIOE    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateQIOE    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateQIOE
PURPOSE: To add an optional extra to the list included with a quoted rate
AUTHOR: Don Kirkby
DATE CREATED: Dec 8, 1998
CALLED BY: Maestro
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CreateQIOE]
	@QRateId	varchar(11),
	@OptExtraId	varchar(6),
	@Qty		varchar(6),
	@LDWDeduct	varchar(11)
AS
	INSERT
	  INTO	quoted_included_optional_extra
		(
		quoted_rate_id,
		optional_extra_id,
		quantity,
		ldw_deductible
		)
	VALUES	(
		CONVERT(int, NULLIF(@QRateId, '')),
		CONVERT(smallint, NULLIF(@OptExtraId, '')),
		CONVERT(smallint, NULLIF(@Qty, '')),
		CONVERT(decimal(9,2), NULLIF(@LDWDeduct, ''))
		)












GO
