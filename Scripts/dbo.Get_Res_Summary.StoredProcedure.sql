USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Get_Res_Summary]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[Get_Res_Summary]
						 
AS
--Select '', 
--'LOCATION NAME', 
----'B-01 YVR Airport', 'YVR Sourth Terminal', 
--'Total'
---- don't need detail for now. Without detail it looks so ugly.
--Union 
--all
Select MOY, DW, Total from 
(SELECT 
	
	UPPER(Substring(DATENAME ( mm , res.Pick_Up_On ),1,3)) MOY,
	
	UPPER(Substring(DATENAME ( w , res.Pick_Up_On ),1,3)) +' '+
	(Case When DAY(res.Pick_Up_On)<10 Then '0' Else '' End)+
	+DATENAME ( dd , res.Pick_Up_On )   DW,
	--Convert(Varchar(20), SUM(Case When loc.Location='B-01 YVR Airport' then 1 Else 0 End)) "B-01 YVR Airport",
	--Convert(Varchar(20),SUM(Case When loc.Location='B-02 YVR South Terminal' then 1 Else 0 End)) "YVR Sourth Terminal",
	Convert(Varchar(20),count(*)) as Total,
	CONVERT(varchar(4),Year(res.Pick_Up_On))+
	Substring(CONVERT(varchar(3),Month(res.Pick_Up_On)+100),2,2) +
	Substring(CONVERT(varchar(3),Day(res.Pick_Up_On)+100),2,2) PUDay
	
	
FROM   dbo.Reservation res 
INNER JOIN
	dbo.Location AS loc 
ON res.Pick_Up_Location_ID = loc.Location_ID
where res.Status in ('o','a') 
	And loc.Rental_location=1   
	And res.Pick_Up_On>=CONVERT(datetime, CONVERT(varchar(12), getdate(), 106))           
	And CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 106)) <=CONVERT(datetime, CONVERT(varchar(12), (getdate()+13), 106))           
		

	
Group by --loc.Location,  
	CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 106))  ,
	Year(res.Pick_Up_On),
	UPPER(Substring(DATENAME ( mm , res.Pick_Up_On ),1,3)) ,
	
	UPPER(Substring(DATENAME ( w , res.Pick_Up_On ),1,3)) +' '+
	(Case When DAY(res.Pick_Up_On)<10 Then '0' Else '' End)+
	+DATENAME ( dd , res.Pick_Up_On ),
	CONVERT(varchar(4),Year(res.Pick_Up_On))+
	Substring(CONVERT(varchar(3),Month(res.Pick_Up_On)+100),2,2) +
	Substring(CONVERT(varchar(3),Day(res.Pick_Up_On)+100),2,2) 
	
	
	
	
	 

Union all

SELECT 
	
	'Period' MOY,
	
	'Total'   DW,
	--Convert(Varchar(20),SUM(Case When loc.Location='B-01 YVR Airport' then 1 Else 0 End)) "B-01 YVR Airport",
	--Convert(Varchar(20),SUM(Case When loc.Location='B-02 YVR South Terminal' then 1 Else 0 End)) "YVR Sourth Terminal",
	Convert(Varchar(20),count(*)) as Total,
	'20781231' PUDay
	-- NumOfRes 
FROM  dbo.Reservation AS res 
INNER JOIN
	dbo.Location AS loc 
ON res.Pick_Up_Location_ID = loc.Location_ID
--where res.Status='a' 
--	and loc.Rental_location=1   
--	and  CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 106)) <=CONVERT(datetime, CONVERT(varchar(12), (getdate()+13), 106))           
	
 where res.Status in ('o','a') 
	And loc.Rental_location=1   
	And res.Pick_Up_On>=CONVERT(datetime, CONVERT(varchar(12), getdate(), 106))           
	And CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 106)) <=CONVERT(datetime, CONVERT(varchar(12), (getdate()+13), 106))           
		
) v
Order by PUDay
GO
