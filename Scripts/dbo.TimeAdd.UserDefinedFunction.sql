USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[TimeAdd]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Function [dbo].[TimeAdd]  
(
	@Time char(05),	
	@Minutes int
)
Returns char(05)
As
	


Begin
Declare @thisDateTime varchar(20)

Select @thisDateTime= 'Jan 1 2000 ' + @Time
SElect @thisDateTime=convert(varchar,dateadd(minute,@Minutes,convert(datetime,@thisDateTime)),114)
 
Return substring(@thisDateTime,1,5)

End
GO
