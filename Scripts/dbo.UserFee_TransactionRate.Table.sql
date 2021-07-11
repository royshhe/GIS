USE [GISData]
GO
/****** Object:  Table [dbo].[UserFee_TransactionRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserFee_TransactionRate](
	[Transaction_Type] [varchar](10) NOT NULL,
	[Transaction_Description] [varchar](20) NOT NULL,
	[Transaction_Rate] [decimal](9, 2) NOT NULL,
	[Transaction_Web_Rate] [decimal](9, 2) NOT NULL
) ON [PRIMARY]
GO
