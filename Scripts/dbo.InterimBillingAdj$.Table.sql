USE [GISData]
GO
/****** Object:  Table [dbo].[InterimBillingAdj$]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterimBillingAdj$](
	[contract_number] [int] NULL,
	[Difference] [decimal](9, 2) NULL,
	[rbr_date] [datetime] NULL,
	[interim_bill_date] [datetime] NULL
) ON [PRIMARY]
GO
