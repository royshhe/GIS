USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CleanIBReconsile]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[CleanIBReconsile]

as

DELETE IB_apapay
Delete IB_Vouchers

GO
