USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDiscountTerms]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PROCEDURE NAME: GetDiscountTerms
PURPOSE: To retrieve the terms of a specific discount
AUTHOR: Don Kirkby
DATE CREATED: Aug 12, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns the terms of the discount
PARAMETERS:
	DiscountId
MOD HISTORY:
Name    Date        Comments
Kenneth Wong - Jan 16, 2006 - Make to compatibility 80
*/
CREATE PROCEDURE [dbo].[GetDiscountTerms]
	@DiscountId Varchar(1)
AS
--Standard settings (DO NOT EDIT!)
DECLARE @sTerm1 As Varchar(255), @sTerm2 As Varchar(255), @sTerm3 As Varchar(255), @sTerm4 As Varchar(255), @sTerm5 As Varchar(255), @sTerm6 As Varchar(255), @sTerm7 As Varchar(255)

         SELECT	@sTerm1=CASE WHEN TermsConds_1 is null THEN '' ELSE TermsConds_1 END,
		@sTerm2=CASE WHEN TermsConds_2 is null THEN '' ELSE TermsConds_2 END, 
 		@sTerm3=CASE WHEN TermsConds_3 is null THEN '' ELSE TermsConds_3 END, 
		@sTerm4=CASE WHEN TermsConds_4 is null THEN '' ELSE TermsConds_4 END, 
 		@sTerm5=CASE WHEN TermsConds_5 is null THEN '' ELSE TermsConds_5 END,
		@sTerm6=CASE WHEN TermsConds_6 is null THEN '' ELSE TermsConds_6 END, 
		@sTerm7=CASE WHEN TermsConds_7 is null THEN '' ELSE TermsConds_7 END 
         FROM Discount 
         WHERE Discount_ID = @DiscountId

	SELECT	@sTerm1 + @sTerm2 + @sTerm3 +
		@sTerm4 + @sTerm5 + @sTerm6 +
		@sTerm7
	RETURN @@ROWCOUNT
GO
