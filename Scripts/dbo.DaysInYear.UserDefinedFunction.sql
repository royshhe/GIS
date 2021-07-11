USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[DaysInYear]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--Select dbo.DaysInYear('2008-12-31')

create FUNCTION [dbo].[DaysInYear]  
(
  @theDate Datetime
)

RETURNS decimal(9,2) 
AS
BEGIN


return datepart(dayofyear,dateadd(Year,1, @theDate-datepart(dayofyear, @theDate)))



END
GO
