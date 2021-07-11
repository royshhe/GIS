USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_MRI_3_Rate_Missing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PROCEDURE NAME: RP_SP_MRI_3_Rate_Missing
PURPOSE: Select all the missing rates delivered from Maestro by BCD number

AUTHOR:	Sharon Li
DATE CREATED: 2005/07/29
USED BY: Maestro Reservation Rate Missing Rpt
*/

CREATE PROCEDURE [dbo].[RP_SP_MRI_3_Rate_Missing] --'01 jan 2011'
(
	@paramBusDate varchar(20) = '23 Apr 1999'
)
AS
-- convert strings to datetime

DECLARE 	@busDate datetime
SELECT	@busDate	= CONVERT(datetime, '00:00:00 ' + @paramBusDate)

SELECT		r.Confirmation_Number, 
			Foreign_Confirm_Number, 
			Pick_Up_On, 
			datename(dw,Pick_Up_On) as DayOfWeek, 
			r.BCD_Number,
			(case when CID is null		then ''
				  when left(cid,2)='BU'	then cid
				else	 dbo.ccmask(cid,6,4)
				end) as CID,
			resMT.ResMadeTime, 
			r.Rate_Code--,BCDRate.Rate_Name
--select *
FROM         dbo.Reservation r inner join RP__Reservation_Make_Time resMT on r.confirmation_number=resMT.Confirmation_Number

WHERE    Last_Changed_On > =@busDate and status='a' and Foreign_Confirm_Number is not null and  Rate_ID is null and 
		  (
		   (Quoted_Rate_ID is null) 
			or not EXISTS 
					( select 1 
					 from Quoted_Time_Period_Rate qtpr
					 where  Time_Period = 'Day' and qtpr.Quoted_Rate_ID = r.Quoted_Rate_ID
					)
			)
			
	
order by r.pick_up_on
GO
