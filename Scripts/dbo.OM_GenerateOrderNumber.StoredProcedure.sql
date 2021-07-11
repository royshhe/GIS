USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OM_GenerateOrderNumber]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





Create Procedure [dbo].[OM_GenerateOrderNumber]
	@CardNumber varchar(20)
AS
INSERT INTO OnlineMartOrder (Credit_card_number)
VALUES (@CardNumber)
SELECT @@IDENTITY AS Order_Number






GO
