USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctFreqFlyPlans]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetCtrctFreqFlyPlans    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctFreqFlyPlans    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctFreqFlyPlans    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctFreqFlyPlans    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctFreqFlyPlans
PURPOSE: To retrieve all Frequent Flyer Plans
AUTHOR: Don Kirkby
DATE CREATED: Aug 11, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each plan name and its id.
MOD HISTORY:
Name    Date        Comments

changed on Oct 8,2004

*/

CREATE PROCEDURE [dbo].[GetCtrctFreqFlyPlans]
@EffDate varchar(25)=NULL
AS
/*	if @EffDate='' or @EffDate is null  -- this is for all records
		begin
			SELECT	frequent_flyer_plan,
				frequent_flyer_plan_id
			  FROM	frequent_flyer_plan
		    
			 ORDER
			    BY	frequent_flyer_plan


		end 
	else  --with date specified or Null for current date
*/
		begin
		
		declare @Eff_date datetime
		
		select @Eff_date= convert(datetime, isnull(@Effdate, cast(getdate() as varchar(25))) )
                if @Effdate='' select @Eff_date=getdate()
		
			SELECT	frequent_flyer_plan,
				frequent_flyer_plan_id
			  FROM	frequent_flyer_plan
		     where Effective_date<=@Eff_Date and termination_date>=@Eff_Date
		          
			 ORDER
			    BY	frequent_flyer_plan
		end 

	RETURN  @@ROWCOUNT
GO
