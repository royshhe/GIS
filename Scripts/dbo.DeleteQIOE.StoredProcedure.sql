USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteQIOE]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteQIOE    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DeleteQIOE    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteQIOE    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: To delete record(s) from quoted_included_optional_extra table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteQIOE]
	@QRateId	varchar(11),
	@OptExtraId	varchar(6)
	
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iQRateId Int,
	@iOptExtraId SmallInt

	SELECT	@iQRateId = CONVERT(Int, NULLIF(@QRateId,'')),
		@iOptExtraId = Convert(SmallInt, NULLIF(@OptExtraId,''))

	Delete From quoted_included_optional_extra
	Where
		Quoted_Rate_ID = @iQRateId
		And Optional_Extra_ID = @iOptExtraId















GO
