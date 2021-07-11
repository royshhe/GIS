USE [GISData]
GO
/****** Object:  Table [dbo].[Interim_Billing_Record$]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interim_Billing_Record$](
	[Contract_Number] [int] NOT NULL,
	[Billing_Date] [datetime] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL
) ON [PRIMARY]
GO
