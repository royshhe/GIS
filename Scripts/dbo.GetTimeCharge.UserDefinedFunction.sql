USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetTimeCharge]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE FUNCTION [dbo].[GetTimeCharge]	--20,30,50,10,200, 800
(
  @Daily_rate decimal(9,2), 
  @Addnl_Daily_rate decimal(9,2), 
  @Weekly_rate decimal(9,2), 
  @Hourly_rate decimal(9,2), 
  @Monthly_rate decimal(9,2),   
  @pIntRentHours decimal(9,2)
)

RETURNS decimal(9,2) 
AS
BEGIN


DECLARE @lIntHours int
Declare @lIntDays  int
Declare @lWeeks int
Declare @lMonths int

Declare @lRemainingHours decimal(9,2)
Declare @lRemainingHoursMonth decimal(9,2)
Declare @lRemainingHoursWeek decimal(9,2)
Declare @lRemainingHoursDay decimal(9,2)



Declare @TimeCharge	decimal(9,2)
Declare @MonthAltCost  decimal(9,2)
Declare @WeekAltCost  decimal(9,2)
Declare @DayAltCost  decimal(9,2)

--print '@lIntHours:'+ convert(varchar(20),@lIntHours)
Select @TimeCharge=0
Select @lRemainingHours=  @pIntRentHours
 
Select @lMonths= @lRemainingHours/720.00 
 
if @Monthly_rate>0   and @lMonths>0
	Begin 
		
		Select @TimeCharge=@Monthly_rate*  @lMonths
		Select @lRemainingHours= @pIntRentHours- @lMonths*720
		
		if @lRemainingHours>0
			Select @MonthAltCost=  @TimeCharge+	@Monthly_rate
	End

 Select @lRemainingHoursMonth=   @lRemainingHours
		 
 
   ---- Print'@@@@@TimeCharge after moth:' +   convert(varchar(10),@lMonths)
	
 If @Weekly_rate>0  and @lRemainingHours>0
	Begin
		SElECT 	@lWeeks=  @lRemainingHours/168	
		SElECT @TimeCharge=@TimeCharge+@Weekly_rate*@lWeeks
		Select @lRemainingHours= @lRemainingHours- @lWeeks*168
		if @lRemainingHours>0
			 Select @WeekAltCost=  @TimeCharge+	@Weekly_rate   
	End
 ---- Print'@lWeeks:' +   convert(varchar(10),@lWeeks)	
  
 Select @lRemainingHoursWeek =   @lRemainingHours
 
 --Compare alternative costs - by adding another month
 If (@MonthAltCost < @TimeCharge) And @MonthAltCost > 0
 Begin
     Select @TimeCharge = @MonthAltCost
     -- Reset the Remain Hours 
     Select @lRemainingHours=   @lRemainingHoursMonth-	720    
 End  
    
  ---- Print'@@@TimeCharge after week:' +   convert(varchar(10),@TimeCharge)
 
 If @Daily_rate>0 and @lRemainingHours>0
 Begin
   SElECT @lIntDays=  dbo.GetRentalDays(@lRemainingHours)	
   SElECT @TimeCharge=@TimeCharge+@Daily_rate*@lIntDays
   SElECT @lRemainingHours=   @lRemainingHours -@lIntDays*24   
   if @lRemainingHours>0
		 Select @DayAltCost=  @TimeCharge+	@Daily_rate    
 End

 -- Print'@lIntDays:' +   convert(varchar(10),@lIntDays)
-- Print'@@@TimeCharge after day:' +   convert(varchar(10),@TimeCharge)

	
 Select @lRemainingHoursDay  =	 @lRemainingHours
	
	
 --Compare alternative costs - by adding another week
 --Also try and use if there is still one or more whole days remaining
 If (@WeekAltCost < @TimeCharge) And @WeekAltCost > 0  
 Begin
		Select @TimeCharge = @WeekAltCost
		Select @lRemainingHours = @lRemainingHoursWeek - 168         
 End  
  -- Print'@@WeekAltCost:' +   convert(varchar(10),@WeekAltCost)
    -- Print'@@@TimeCharge after alt week:' +   convert(varchar(10),@TimeCharge)
 if @Hourly_rate>0	 And  @lRemainingHours>0   
 Begin
	   SElECT @lIntHours=  @lRemainingHours 
	   SElECT @TimeCharge=@TimeCharge+@Hourly_rate*@lIntHours	     
 End  
 
 If (@DayAltCost < @TimeCharge) And @DayAltCost > 0  
 Begin
		Select @TimeCharge = @DayAltCost
		Select @lRemainingHours = 0         
 End 	
 	 
 Return @TimeCharge 
	 
  End

GO
