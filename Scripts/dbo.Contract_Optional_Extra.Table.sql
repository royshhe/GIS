USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Optional_Extra]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Optional_Extra](
	[Contract_Number] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Included_In_Rate] [char](1) NOT NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Rent_From] [datetime] NOT NULL,
	[Sold_At_Location_ID] [smallint] NOT NULL,
	[Rent_To] [datetime] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Daily_Rate] [decimal](7, 2) NOT NULL,
	[Weekly_Rate] [decimal](7, 2) NOT NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[Sold_On] [datetime] NULL,
	[Sold_By] [varchar](20) NULL,
	[Unit_Number] [varchar](20) NULL,
	[Coupon_Code] [varchar](20) NULL,
	[HST2_Exempt] [bit] NULL,
	[Sequence] [smallint] NOT NULL,
	[Flat_Rate] [decimal](7, 2) NULL,
	[Status] [char](2) NULL,
	[Return_Location_ID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Optional_Extra] ADD  CONSTRAINT [DF__Contract___Quant__60A8F2BD]  DEFAULT (1) FOR [Quantity]
GO
ALTER TABLE [dbo].[Contract_Optional_Extra] ADD  DEFAULT (0) FOR [Flat_Rate]
GO
