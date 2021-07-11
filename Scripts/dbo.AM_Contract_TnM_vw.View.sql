USE [GISData]
GO
/****** Object:  View [dbo].[AM_Contract_TnM_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[AM_Contract_TnM_vw]
AS
SELECT     cci.Contract_Number, bt.Transaction_Date, SUM(cci.Amount - cci.GST_Amount_Included - cci.PST_Amount_Included - cci.PVRT_Amount_Included) 
                      AS TnM_Amount, bt.RBR_Date, bt.Business_Transaction_ID, dbo.AM_CheckIn_RBR_Date.Checkin_RBR_Date, 
                      dbo.Contract_Rental_Days_vw.Rental_Day
FROM         dbo.Contract_Charge_Item cci WITH(NOLOCK)  INNER JOIN
                      dbo.Business_Transaction bt WITH(NOLOCK)  ON cci.Business_Transaction_ID = bt.Business_Transaction_ID INNER JOIN
                      dbo.AM_CheckIn_RBR_Date WITH(NOLOCK)  ON cci.Contract_Number = dbo.AM_CheckIn_RBR_Date.Contract_Number 
					 --AND bt.RBR_Date <= dbo.AM_CheckIn_RBR_Date.Checkin_RBR_Date + 1 
INNER JOIN
                      dbo.Contract_Rental_Days_vw WITH(NOLOCK)  ON cci.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number
WHERE     (cci.Charge_Type IN (10, 11, 50, 51, 52))
GROUP BY cci.Contract_Number, bt.Transaction_Date, bt.RBR_Date, bt.Business_Transaction_ID, dbo.AM_CheckIn_RBR_Date.Checkin_RBR_Date, 
                      dbo.Contract_Rental_Days_vw.Rental_Day
GO
