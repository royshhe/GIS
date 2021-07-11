USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_Coupon]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_Coupon](
	[Coupon_Code] [varchar](25) NOT NULL,
	[Description] [varchar](100) NULL,
	[Bonus_Offer_Code] [varchar](8) NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_date] [datetime] NOT NULL,
 CONSTRAINT [PK_AirMiles_Coupon_Code] PRIMARY KEY CLUSTERED 
(
	[Coupon_Code] ASC,
	[Effective_Date] ASC,
	[Termination_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
