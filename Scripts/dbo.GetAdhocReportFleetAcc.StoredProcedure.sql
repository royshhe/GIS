USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdhocReportFleetAcc]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Jun 05, 2001
--  Details: 	 ad hoc report
--  Tracker:	 Issue# 1848
---------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetAdhocReportFleetAcc]

as

select   
	left(vs.value,25) as 'Current Vehicle Status' ,
	 v.Unit_Number as 'Unit Number' ,
	v.Serial_Number as 'Serial Number' ,
	vmy.Model_Year as 'Year' ,
	vmy.Model_Name as 'Model' ,
	left( rs.value,30 ) as 'Rental Status' ,
	v.Current_Km as 'KM' ,
	v.Ownership_Date as 'Transfer Date' ,
	loc.location as 'Location' ,
	v.Current_Licence_Plate as 'Licence'

from vehicle v

left join (
	select Code , value from lookup_table
	where Category = 'Vehicle Status'
      ) vs
	on vs.code = v.Current_Vehicle_Status
left join Vehicle_Model_Year vmy
	on  v.Vehicle_Model_ID = vmy.Vehicle_Model_ID
left join location loc
	on v.Current_Location_ID = loc.location_id
left join (
	select code , value
	from lookup_table
	where Category = 'Vehicle Rental Status' 
      ) rs	on rs.Code = v.Current_Rental_Status

where  ( v.Foreign_Vehicle_Unit_Number is null )

order by v.Current_Vehicle_Status , v.Unit_Number






GO
