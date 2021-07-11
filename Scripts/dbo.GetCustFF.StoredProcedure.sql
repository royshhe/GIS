USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustFF]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.GetCustFF    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCustFF    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCustFF    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCustFF    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the frequent flyer plan information for the given customer id.
MOD HISTORY:
Name	Date		Comment
Don K	Nov 3 1998	Renamed member_number to ff_member_number
			Needs to be rewritten for new PK
*/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetCustFF] --1793
	@CustId Varchar(10)
AS
	DECLARE	@nCustId Integer
	SELECT	@nCustId = Convert(Int, NULLIF(@CustId, ""))

	SELECT A.Frequent_Flyer_Plan_ID, B.Airline, B.Frequent_Flyer_Plan,
	       A.FF_Member_Number
	FROM   Frequent_Flyer_Plan_Member A,
	       Frequent_Flyer_Plan B
	WHERE  A.Frequent_Flyer_Plan_ID = B.Frequent_Flyer_Plan_ID
	AND    Customer_ID = @nCustId
        And (A.Frequent_Flyer_Plan_ID not IN
                          (SELECT     Frequent_Flyer_Plan_ID
                            FROM          Frequent_Flyer_Plan
                            WHERE      (Termination_Date < GETDATE())))



GO
