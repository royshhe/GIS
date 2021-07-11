USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCMod10Check]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetCCMod10Check]
@CCTypeID varchar(20)
AS
SELECT
	
	Mod_10_Check
FROM
	Credit_Card_Type
where DeleteFlag<>1 and
Credit_Card_Type_ID =@CCTypeID
RETURN 1
GO
