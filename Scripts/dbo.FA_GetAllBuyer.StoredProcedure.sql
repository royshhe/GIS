USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetAllBuyer]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[FA_GetAllBuyer]

AS

SELECT    Buyer_Name, Customer_Code , PSTable
FROM         dbo.FA_Buyer
Order By Buyer_Name
Return 1
GO
