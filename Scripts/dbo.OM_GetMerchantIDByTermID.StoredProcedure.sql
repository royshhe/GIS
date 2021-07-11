USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OM_GetMerchantIDByTermID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO














/****** Object:  Stored Procedure dbo.OM_GetMerchantIDByTermID    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.OM_GetMerchantIDByTermID    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.OM_GetMerchantIDByTermID    Script Date: 1/11/99 1:03:16 PM ******/

/* Don K - Mar 15 1999 - Used outer join to bgt_armaster and aractcus */
CREATE PROCEDURE [dbo].[OM_GetMerchantIDByTermID] --'wsbhq243'
@TermID varchar(20)
AS


SELECT     dbo.Location.Merchant_ID
FROM         dbo.Terminal INNER JOIN
                      dbo.Location ON dbo.Terminal.Location_ID = dbo.Location.Location_ID
WHERE dbo.Terminal.Terminal_ID=@TermID

Return 1




GO
