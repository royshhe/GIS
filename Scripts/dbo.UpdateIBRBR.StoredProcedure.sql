USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateIBRBR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
















/****** Object:  Stored Procedure dbo.UpdateIBRBR    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.UpdateIBRBR    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateIBRBR    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: UpdateIBRBR
PURPOSE: To record the date that the GL was generated.
AUTHOR: Roy He
DATE CREATED: Aug 25, 2008
CALLED BY: AMEFT
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateIBRBR]
	@RBRDate varchar(24)
AS
	Declare	@dRBRDate DateTime
	Select		@dRBRDate = CONVERT(datetime, NULLIF(@RBRDate,''))

	UPDATE	rbr_date
	   SET	Date_IB_Generated = GETDATE()
	 WHERE	rbr_date = @dRBRDate


GO
