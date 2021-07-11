USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetAllLessee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[FA_GetAllLessee]

AS

SELECT    Lessee_Name, Lessee_ID,Customer_Code 
FROM         dbo.FA_Lessee
Order By Lessee_Name
Return 1
GO
