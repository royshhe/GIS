USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_Coupon]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_Coupon](
	[Coupon_Code] [varchar](25) NOT NULL,
	[Description] [varchar](25) NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_date] [datetime] NOT NULL
) ON [PRIMARY]
GO
