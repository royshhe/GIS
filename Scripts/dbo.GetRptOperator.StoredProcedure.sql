USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptOperator]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptOperator
PURPOSE: To retrieve a list of operators (users)
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
Don K	Jun 29 1999 Get names from business_transaction instead of
		reservation history. Add flags to include reservations,
		contracts, or sales contracts
Sli	Aug 17 2005 Add one more parameter for filtering terminated operators		
*/
CREATE PROCEDURE [dbo].[GetRptOperator] --1,0,0,1
	@IncludeResv		char(1) = '1',
	@IncludeCtrct		char(1) = '0',
	@IncludeSalesCtrct	char(1) = '0',
	@ActiveOpr		char(1) = '1' 
AS
	DECLARE	@bResv		bit,
		@bCtrct		bit,
		@bSalesCtrct	bit,
		@bActiveOpr	bit
	SELECT	@bResv		= CAST(NULLIF(@IncludeResv, '') AS bit),
		@bCtrct		= CAST(NULLIF(@IncludeCtrct, '') AS bit),
		@bSalesCtrct	= CAST(NULLIF(@IncludeSalesCtrct, '') AS bit)
	IF @ActiveOpr <> ""  SELECT @bActiveOpr = CAST(NULLIF(@ActiveOpr, '') AS bit)
	

	SELECT
      DISTINCT	BT.user_id
	  FROM	business_transaction BT
	  inner join GisUsers U on BT.user_id = U.user_name
	 WHERE	(  @bResv = 1
		OR BT.confirmation_number IS NULL
		)
	   AND	(  @bCtrct = 1
		OR BT.contract_number IS NULL
		)
	   AND	(  @bSalesCtrct = 1
		OR BT.sales_contract_number IS NULL
		)
	   AND  (  @ActiveOpr = '' 
		OR U.active = @bActiveOpr
		)
	 ORDER
	    BY	BT.user_id
















GO
