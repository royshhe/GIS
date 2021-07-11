USE [GISData]
GO
/****** Object:  Table [dbo].[TollAdminCharge]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TollAdminCharge](
	[Contract_number] [int] NULL,
	[Issuer] [varchar](50) NULL,
	[Admin_Charge] [decimal](9, 2) NULL,
	[Transaction_Date] [datetime] NULL
) ON [PRIMARY]
GO
