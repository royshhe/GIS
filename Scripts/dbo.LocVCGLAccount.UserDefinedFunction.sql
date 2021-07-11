USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[LocVCGLAccount]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function [dbo].[LocVCGLAccount]
(
	@BaseGLAccount VarChar(45),
    @LocatonAcctgSeg VarChar(15),
	@VCAcctgSeg VarChar(15)
) 

RETURNS VarChar(45)
AS
BEGIN
		DECLARE @LocVCGLAccount  VarChar(45)
      
		IF @LocatonAcctgSeg IS NOT NULL 
			SELECT @BaseGLAccount=Replace(@BaseGLAccount,'XX', @LocatonAcctgSeg)
        
               

		IF @VCAcctgSeg IS NOT NULL 
			SELECT @LocVCGLAccount=Replace(@BaseGLAccount,'YY', @VCAcctgSeg)
        Else 
			SELECT @LocVCGLAccount=@BaseGLAccount

		RETURN @LocVCGLAccount
END
 
GO
