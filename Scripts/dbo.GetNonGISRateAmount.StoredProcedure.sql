USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateAmount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetNonGISRateAmount    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateAmount    Script Date: 2/16/99 2:05:41 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetNonGISRateAmount]
@QuotedRateID 	Varchar(10),
@ChargeType	Varchar(15)	-- Regular, Late
AS
DECLARE @iRateId Int
SELECT 	@iRateId = Convert(Int, NULLIF(@QuotedRateId,""))
SELECT 	@ChargeType = NULLIF(@ChargeType,"")
SELECT
	Time_period,
	Time_period_start,
	Time_period_end,
	Amount,
	(Case
		When Km_Cap IS NULL and Per_KM_Charge=0  Then
				'Unlimited'
		When Km_Cap IS NULL and Per_KM_Charge<>0 Then
				'0'

		Else
			Convert(varchar, Km_Cap)
	End
              )

FROM 

Quoted_Time_Period_Rate INNER JOIN
Quoted_Vehicle_Rate ON 
Quoted_Time_Period_Rate.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID

WHERE
	Quoted_Time_Period_Rate.Quoted_Rate_ID = @iRateId
	AND Quoted_Time_Period_Rate.Rate_Type = @ChargeType
ORDER BY
	Time_Period, Time_Period_Start
RETURN @@ROWCOUNT


















GO
