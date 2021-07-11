USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[CutOffDate]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[CutOffDate] 
(
   @pDate    DATETIME
)

RETURNS DateTime
AS
BEGIN
Declare @adjDate DateTime
Select @adjDate=
				(Case 
					When Month(@pDate) in (1,3,5,7,8,10,12)  then  Dateadd(d, 6,@pDate)
					When Month(@pDate) in (4,6,9,11)  Then Dateadd(d, 5,@pDate)
					When Month(@pDate) =2   Then 
						(Case When dbo.IsLeapYear(@pDate)=1 Then Dateadd(d, 4,@pDate)
							Else Dateadd(d, 3,@pDate)
							End
						)
				End)
Return @adjDate

End
GO
