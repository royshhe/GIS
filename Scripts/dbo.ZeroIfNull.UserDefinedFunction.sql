USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[ZeroIfNull]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[ZeroIfNull] 
(
  @pValue decimal(9,2)
)

RETURNS decimal(9,2) 
AS
BEGIN

 
Return (Case When @pValue is Not null then @pValue Else 0 End)

 


END
GO
