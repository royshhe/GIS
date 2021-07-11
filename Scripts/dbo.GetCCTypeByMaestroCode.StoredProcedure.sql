USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCTypeByMaestroCode]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.GetCCTypeByMaestroCode    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetCCTypeByMaestroCode    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCCTypeByMaestroCode    Script Date: 1/11/99 1:03:15 PM ******/
/*
PROCEDURE NAME: GetCCTypeByMaestroCode
PURPOSE: To retrieve a credit card type based on the Maestro Code
AUTHOR: Don Kirkby
DATE CREATED: Oct 16, 1998
CALLED BY: Customer
MOD HISTORY:
Name    Date        Comments
Don K	Dec 15 1998 Added expiry_required
*/
CREATE PROCEDURE [dbo].[GetCCTypeByMaestroCode]  -- 'vi'
	@MaestroCode	varchar(2)
AS
	/* 10/21/99 - do nullif outside of SQL statements */

	SELECT	@MaestroCode = NULLIF(@MaestroCode,'')

	SELECT	credit_card_type_id,
    0 expiry_required,CONVERT(tinyint,Electronic_Authorization)
--	 CONVERT(tinyint, expiry_required)
	  FROM	credit_card_type
	 WHERE	maestro_code = @MaestroCode
	RETURN @@ROWCOUNT
GO
