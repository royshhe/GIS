USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_7_Fleet_Mix_Monthly_Base1]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*-------------------------------------------------------------------------------------------------------------------------------------
-- Procedure Name:	RP_SP_Flt_7_Fleet_Mix_Monthly_Base1
-- Purpose: 		Input vehicle data into RP_FleetMixMonthly table 
-- Author:		Vivian Leung
-- Date Created: 		03 Dec 2001
-- Modification:	
			Name 		Date		Comments
		
----------------------------------------------------------------------------------------------------------------------------------------*/

CREATE procedure [dbo].[RP_SP_Flt_7_Fleet_Mix_Monthly_Base1]

as

insert into RP_FleetMixMonthly
select 	Rpt_Date, 
	Current_Location_ID, 
	Vehicle_Class_Code, 	
	Vehicle_Type_id,
	count(*)
from 	RP_Flt_7_Fleet_Mix_Monthly_Base with(nolock)
group by	Rpt_Date, 
		Vehicle_Type_id,
		Current_Location_ID, 
		Vehicle_Class_Code








GO
