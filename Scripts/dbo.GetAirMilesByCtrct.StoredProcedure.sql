USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAirMilesByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetAirMilesByCtrct
PURPOSE: To retrieve Air Miles Card by contract number
AUTHOR: Roy he
DATE CREATED: Dec 11, 2006
CALLED BY: Contract
REQUIRES:
ENSURES: Air Miles Card Information
PARAMETERS:
	CtrctNum
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAirMilesByCtrct]
	@CtrctNum	varchar(11)
AS
	/* 3/11/99 - cpy modified - use 0/1 instead of N/Y for Included_In_Rate */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))
	SELECT  dbo.Air_Miles_Card.Card_Type_ID, 
		dbo.Air_Miles_Card.CARD_number, 		
		dbo.Air_Miles_Card.Last_Name, 
		dbo.Air_Miles_Card.First_Name
	FROM    dbo.Contract INNER JOIN
	                     		dbo.Frequent_Flyer_Plan ON dbo.Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID 
			     INNER JOIN
	                      		dbo.Air_Miles_Card ON dbo.Contract.FF_Member_Number = dbo.Air_Miles_Card.CARD_number
	WHERE   (dbo.Contract.Contract_number= @nCtrctNum) and  (dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Air Miles')
	 
	RETURN @@ROWCOUNT









GO
