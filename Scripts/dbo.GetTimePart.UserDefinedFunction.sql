USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetTimePart]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create FUNCTION [dbo].[GetTimePart] 
(
  @pDateTime DateTime
)

RETURNS Varchar(5) 
AS
BEGIN
Declare @dTime Varchar(5)

Select @dTime =(Case When datepart(hour, @pDateTime)<10 then '0' + Convert(Varchar(2), datepart(hour, @pDateTime))
										   Else Convert(Varchar(2), datepart(hour, @pDateTime))
						   End)
                            +':'
                            +(Case When datepart(minute, @pDateTime)<10 then '0' + Convert(Varchar(2), datepart(minute, @pDateTime))
										   Else Convert(Varchar(2), datepart(minute, @pDateTime))
						   End)

return @dTime


END
GO
