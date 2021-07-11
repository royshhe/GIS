USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetRentalDays]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE FUNCTION [dbo].[GetRentalDays] 
(
  @pIntRentHours decimal(9,2)
)

RETURNS decimal(9,2) 
AS
BEGIN


DECLARE @lIntRentDays1 int
declare @lIntRentDays2 decimal(9,2)
DECLARE @lIntHours decimal(9,2)
declare @lTotalRentalDays decimal(9,2)

select @pIntRentHours=CEILING(@pIntRentHours)
select @lIntRentDays1=(@pIntRentHours/24.00)
select @lIntHours= (@pIntRentHours-@lIntRentDays1*24)  --convert(int,@pIntRentHours) % 24

--print '@lIntHours:'+ convert(varchar(20),@lIntHours)

if @lIntHours>=2
	select @lIntRentDays2=1
else
begin
	select @lIntRentDays2=@lIntHours/2.0
	
--print '@lIntRentDays2:'+ convert(varchar(20),@lIntRentDays2)
end 



select @lTotalRentalDays=@lIntRentDays1+@lIntRentDays2
--print @lTotalRentalDays

if @lTotalRentalDays<1
	select @lTotalRentalDays=1
return @lTotalRentalDays


END





GO
