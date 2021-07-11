USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[CMask]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







Create FUNCTION [dbo].[CMask] 
(
  @pstrCCNumber  varchar(20),
  @pMaskChar char(1),
  @pintPreFixLen Int,
  @pintSubFixLen Int
)

RETURNS Varchar(20)
AS
BEGIN




    Declare @lstrPrefix varchar(20)
    Declare @lstrSubFix varchar(20)
    Declare @lstrMask Varchar(20)

    
    If Len(@pstrCCNumber) <= (@pintPreFixLen + @pintSubFixLen)
        return @pstrCCNumber
    
        
    Select @lstrPrefix = Left(@pstrCCNumber, @pintPreFixLen)
    Select @lstrSubFix = Right(@pstrCCNumber, @pintSubFixLen)
    Select @lstrMask = Space(Len(@pstrCCNumber) - (@pintPreFixLen + @pintSubFixLen))
    Select @lstrMask = Replace(@lstrMask,  ' ', @pMaskChar)
  

    Return @lstrPrefix + @lstrMask +@lstrSubFix





END







GO
