USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateQRateCtgy]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateQRateCtgy    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateQRateCtgy    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateQRateCtgy    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateQRateCtgy
PURPOSE: To add a category to a Quoted Vehicle Rate
AUTHOR: Don Kirkby
DATE CREATED: Dec 2, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CreateQRateCtgy]
	@QRateId	varchar(11),
	@CtgyCode	varchar(2)
AS
	INSERT
	  INTO	quoted_rate_category
		(
		quoted_rate_id,
		maestro_rate_category_code
		)
	VALUES	(
		CONVERT(int, NULLIF(@QRateId, '')),
		NULLIF(@CtgyCode, '')
		)












GO
