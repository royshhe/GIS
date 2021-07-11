USE [GISData]
GO
/****** Object:  View [dbo].[Check_Contract_Reservation]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Check_Contract_Reservation]
AS
SELECT TOP 100 PERCENT dbo.Contract.Contract_Number, 
      dbo.Contract.Pick_Up_Location_ID, dbo.Contract.Pick_Up_On, 
      dbo.Contract.Vehicle_Class_Code, dbo.Contract.Status, dbo.Contract.Last_Update_On, 
      dbo.Reservation.Confirmation_Number, dbo.Reservation.Status AS Expr1, 
      dbo.Reservation.Last_Changed_On
FROM dbo.Contract INNER JOIN
      dbo.Reservation ON 
      dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number
WHERE (dbo.Reservation.Status IN ('A', 'C', 'N')) AND (dbo.Contract.Status NOT IN ('CA')) 
      AND (dbo.Contract.Last_Update_On > '01 jan 2008')
ORDER BY dbo.Contract.Last_Update_On
GO
