USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_15_Reservation_Duplicate_Booking]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[RP_SP_Res_15_Reservation_Duplicate_Booking] 
( 
	@paramBookDate varchar(20) = '01 Apr 1999' 
	
)
AS
-- convert strings to datetime
DECLARE 	@bookDate datetime 
	

SELECT	@bookDate	= CONVERT(datetime, '00:00:00 ' + @paramBookDate) 
	
Select  res.Foreign_Confirm_Number, res.First_Name, res.Last_Name, res.Pick_Up_On, vc.Vehicle_Class_Name, rmt.transaction_date
from dbo.Reservation Res
Inner Join
(SELECT  count(*) as iCount,  res.First_Name, res.Last_Name, convert(varchar(20), res.Pick_Up_On,111) as PUDate--, rmt.ResMadeTime
FROM  dbo.Reservation AS res INNER JOIN
(Select distinct maestro.foreign_confirm_number, transaction_date from maestro
where maestro_data like '/ACTCR\%' 
 and  transaction_date>=@bookDate 
and transaction_date<@bookDate+1 )
               
 AS rmt ON res.Foreign_Confirm_Number = rmt.Foreign_Confirm_Number 
 where res.status in ('a')
Group by  res.First_Name, res.Last_Name, convert(varchar(20), res.Pick_Up_On,111)
having count(*)>1
)DoubleBooking
ON Res.First_Name=DoubleBooking.First_Name
And Res.Last_Name=DoubleBooking.Last_Name
And convert(varchar(20), res.Pick_Up_On,111)=DoubleBooking.PUDate
INNER JOIN
(Select maestro.foreign_confirm_number, transaction_date from maestro 
where maestro_data like '/ACTCR\%' 
and  transaction_date>=@bookDate  
and transaction_date<@bookDate+1 )
 AS rmt ON res.Foreign_Confirm_Number = rmt.Foreign_Confirm_Number 
Inner Join Vehicle_Class vc
On Res.Vehicle_class_code=vc.Vehicle_class_code
 where res.status in ('a')
order by res.First_Name, res.Last_Name, convert(varchar(20), res.Pick_Up_On,111),rmt.transaction_date
 
GO
