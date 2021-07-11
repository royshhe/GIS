USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[InitialUperCase]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE FUNCTION [dbo].[InitialUperCase] 
(
  @pStrWords Varchar(50)
)

RETURNS Varchar(50) 
AS
BEGIN



Declare @lStrWord Varchar(50)
Declare @i Int




--select @City='van city'
select @i= CHARINDEX(' ', @pStrWords)


if @i=0 
	select @lStrWord=UPPER(SUBSTRING(@pStrWords, 1, 1))  + 	SUBSTRING(@pStrWords, 2, LEN(@pStrWords ) - 1) 
else
	select @lStrWord=UPPER(SUBSTRING(@pStrWords, 1, 1))  +SUBSTRING(@pStrWords, 2,  @i-1)+ UPPER(SUBSTRING(@pStrWords, @i+1, 1))+SUBSTRING(@pStrWords, @i+2, LEN(@pStrWords ) - (@i+1)) 



return @lStrWord

END





GO
