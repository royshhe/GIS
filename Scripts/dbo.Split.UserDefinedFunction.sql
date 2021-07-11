USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[Split] (@String nvarchar(4000), @Delimiter char(1))
Returns @Results Table (Items nvarchar(4000))
As
Begin
Declare @Index int
Declare @Slice nvarchar(4000)

Select @Index = 1
If @String Is NULL Return

While @Index != 0
Begin
Select @Index = CharIndex(@Delimiter, @String)
If @Index <> 0

Select @Slice = left(@String, @Index - 1)

else

Select @Slice = case when @String='*'
							then ''
							else @String
				end			
Insert into @Results(Items) Values (@Slice)
Select @String = right(@String, Len(@String) - @Index)

If Len(@String) = 0 break

End
Return
End





GO
