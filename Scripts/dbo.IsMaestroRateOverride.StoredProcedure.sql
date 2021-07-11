USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsMaestroRateOverride]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[IsMaestroRateOverride]
	@BCDNumber  VarChar(12)
AS


	Declare @ret int


	SELECT     Maestro_Rate_Override
	FROM         dbo.Organization
	where BCD_Number=@BCDNumber and Maestro_Rate_Override=1 
	And	 inactive=0


	If @@ROWCOUNT = 0
		Select @ret = 0
	Else
		Select @ret = 1

	RETURN @ret
GO
