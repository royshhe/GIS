USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAMAdjustment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: Check to see if Adjustment Exists
MOD HISTORY:
Name    Date        Comments
Roy He - Feb 05 2008
*/

Create PROCEDURE [dbo].[GetAMAdjustment]  -- '1129980', '83014512329'
	@ContractNumber varchar(20)	
AS

Declare @iCtrctNum Int

Select @iCtrctNum = Convert(int, NULLIF(@ContractNumber,''))
     

	SELECT    *
	FROM         dbo.Air_Miles_Points_Adjustment
	where  Contract_Number=@iCtrctNum
	
      RETURN @@ROWCOUNT

GO
