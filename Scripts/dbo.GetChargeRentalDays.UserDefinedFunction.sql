USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetChargeRentalDays]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[GetChargeRentalDays] 
(
  @pRentalMinutes int
)

RETURNS int 
AS
BEGIN


DECLARE @lIntRentDays1 int
declare @lIntRentDays2 int
DECLARE @lIntMinutes int 
declare @lTotalRentalDays int 

 
select @lIntRentDays1=(@pRentalMinutes/1440.00)
select @lIntMinutes= (@pRentalMinutes-@lIntRentDays1*1440)  --convert(int,@pIntRentHours) % 24

--print '@lIntMinutes:'+ convert(varchar(20),@lIntMinutes)
Select @lIntRentDays2=0
if @lIntMinutes>=60
	select @lIntRentDays2=1
 	
--print '@lIntRentDays2:'+ convert(varchar(20),@lIntRentDays2)
 



select @lTotalRentalDays=@lIntRentDays1+@lIntRentDays2
--print @lTotalRentalDays

if @lTotalRentalDays<1
	select @lTotalRentalDays=1
return @lTotalRentalDays


END





GO
