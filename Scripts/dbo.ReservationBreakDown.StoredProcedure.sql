USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ReservationBreakDown]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Roy He
-- Date:	Jan 30 2003
-- Purpose: 	Report for Reservation Break Down
--------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[ReservationBreakDown] 
(
@BeginDate datetime,
@EndDate datetime
)
As

SELECT     

ReservationNumber = CASE WHEN dbo.Reservation.Confirmation_Number IS NOT NULL 
                         THEN dbo.Reservation.Confirmation_Number 
		         ELSE dbo.Reservation.Foreign_Confirm_Number 
		     END, 

dbo.Contract.Contract_Number, 
dbo.Reservation.Status,
dbo.Reservation.Source_Code, 
dbo.Vehicle_Class.Vehicle_Class_Name, 
SUM(dbo.Contract_Charge_Item.Amount) AS Revenue
into #ReservationSummary
FROM         dbo.Vehicle_Class INNER JOIN
                      dbo.Contract ON dbo.Vehicle_Class.Vehicle_Class_Code = dbo.Contract.Vehicle_Class_Code INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number RIGHT OUTER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number
where  dbo.Reservation.Pick_Up_On between @BeginDate  and @EndDate
GROUP BY dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Contract.Contract_Number, dbo.Reservation.Status,dbo.Reservation.Source_Code, dbo.Vehicle_Class.Vehicle_Class_Name



SELECT     

Source_Code, 
Vehicle_Class_Name,
Sum(case	when Status = 'O'
			then 1
			else 0
		end)						as Opened,
Sum(case	when Status = 'A'
			then 1
			else 0
		end)						as Active,

Sum(case	when Status = 'N'
			then 1
			else 0
		end)						as NoShow,
Sum(case	when Status = 'C'
			then 1
			else 0
		end)						as Cancelled,


SUM(Revenue) AS Revenue

FROM  #ReservationSummary  
group by Status,Source_Code, 
Vehicle_Class_Name
order by Source_Code,Status,Vehicle_Class_Name
GO
