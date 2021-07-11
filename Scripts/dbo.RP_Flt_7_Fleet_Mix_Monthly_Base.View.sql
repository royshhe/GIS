USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_7_Fleet_Mix_Monthly_Base]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- View Name:	 RP_Flt_7_Fleet_Mix_Monthly_Base
-- Purpose: 	Select all the rentable vehicles of Budget BC in each location to create the Fleet Mix Monthly report		
-- Author:	Vivian Leung
-- Date Created: 	03 Dec 2001
-- Used By:	RP_SP_Flt_7_Fleet_Mix_Monthly_Base1
-- Modification:	
		Name 		Date		Comments
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE view [dbo].[RP_Flt_7_Fleet_Mix_Monthly_Base]
as
select  	left(getdate(), 11)		 as Rpt_Date,
	v.Unit_Number,
	vc.Vehicle_Type_ID,
    	l.Location 			as Current_Location_Name,
    	v.Current_Rental_Status 		as Vehicle_Rental_Status,
    	vc.Vehicle_Class_Code,
    	vc.Vehicle_Class_Name,
    	v.Current_Location_ID
from  	Vehicle v WITH(NOLOCK)
	inner join
    	Location l
		on  v.Current_Location_ID = l.Location_ID
	inner join
	Vehicle_Class vc
		on v.Vehicle_Class_Code = vc.Vehicle_Class_Code
     	inner join
    	Lookup_Table lt
		on v.Owning_Company_ID = convert(smallint,lt.Code)
where   v.Current_Vehicle_Status = 'd'
	and
	(lt.Category = 'BudgetBC Company')
	and
	v.Deleted = 0




GO
