USE [GISData]
GO
/****** Object:  Table [dbo].[Coupon]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Coupon](
	[Cntry_Sta_number] [varchar](25) NULL,
	[Coupon_Number] [varchar](25) NULL,
	[Coupon_Value] [decimal](9, 2) NULL,
	[Currency_Indicator] [char](10) NULL,
	[Min_LOR] [int] NULL,
	[Max_LOR] [int] NULL,
	[Description_1] [varchar](100) NULL,
	[Description_2] [varchar](150) NULL,
	[Coupon_Type] [char](10) NULL,
	[Effective_Date] [datetime] NULL,
	[Terminate_Date] [datetime] NULL,
	[Program_Name] [varchar](100) NULL
) ON [PRIMARY]
GO
