USE [GISData]
GO
/****** Object:  View [dbo].[RT_RateAmount_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
VIEW NAME: RT_Contract_BaseRate_Amount
PURPOSE: Get Rate Amount Listing
	 
AUTHOR:	Roy He
DATE CREATED: 2005/08/01
USED BY: CSR Incentive Report
MOD HISTORY:
Name 		Date		Comments
				is not defined in the lookup table.
*/

CREATE VIEW [dbo].[RT_RateAmount_Base]
AS
SELECT DISTINCT 
                      RVC.Vehicle_Class_Code, RCA.Rate_ID, RTP.Km_Cap, RCA.Rate_Level, RTP.Time_Period, RTP.Time_Period_Start, RTP.Time_period_End, 
                      RCA.Amount, RCA.Type, RVC.Per_KM_Charge
FROM         dbo.Rate_Charge_Amount RCA INNER JOIN
                      dbo.Rate_Vehicle_Class RVC ON RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID AND RCA.Rate_ID = RVC.Rate_ID INNER JOIN
                      dbo.Rate_Time_Period RTP ON RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID AND RCA.Rate_ID = RTP.Rate_ID
WHERE     (RCA.Type = 'Regular') AND (RCA.Termination_Date = 'Dec 31 2078 11:59PM') AND (RTP.Termination_Date = 'Dec 31 2078 11:59PM') AND 
                      (RVC.Termination_Date = 'Dec 31 2078 11:59PM')



GO
