USE [GISData]
GO
/****** Object:  View [dbo].[CC_Payment_CC]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/****** Object:  View dbo.CC_Payment_CC    Script Date: 2/18/99 12:11:39 PM ******/
/****** Object:  View dbo.CC_Payment_CC    Script Date: 2/16/99 2:05:38 PM ******/
CREATE VIEW [dbo].[CC_Payment_CC] AS
	SELECT	Distinct CCP.Contract_Number, 
			CCP.Credit_Card_Key, 
			CC.Credit_Card_Type_Id,
			CC.Credit_Card_Number
	FROM	Credit_Card_Payment CCP,
		Credit_Card CC
	WHERE	CCP.Credit_Card_Key = CC.Credit_Card_Key







GO
