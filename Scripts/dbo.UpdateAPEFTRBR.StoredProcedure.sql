USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAPEFTRBR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PROCEDURE NAME: UpdateAPEFTRBR
PURPOSE: To record the date that the GL was generated.
AUTHOR: Roy He
DATE CREATED: Jan 5, 2007
CALLED BY: AMEFT
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
Create PROCEDURE [dbo].[UpdateAPEFTRBR]
	@RBRDate varchar(24)
AS
	Declare	@dRBRDate DateTime
	Select		@dRBRDate = CONVERT(datetime, NULLIF(@RBRDate,''))

	UPDATE	rbr_date
	   SET	Date_APEFT_Submitted = GETDATE()
	 WHERE	rbr_date = @dRBRDate
GO
