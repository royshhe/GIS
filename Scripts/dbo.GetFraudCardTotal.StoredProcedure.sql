USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetFraudCardTotal]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetFraudCardTotal]
AS
SELECT	Count(*)
FROM		fraud_credit_Cards


GO
