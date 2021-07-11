USE [GISData]
GO
/****** Object:  Table [dbo].[AR_Credit_Authorization]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AR_Credit_Authorization](
	[Customer_Code] [varchar](15) NOT NULL,
	[Expected_Open_Contract_Charges] [decimal](9, 2) NOT NULL,
	[Daily_Contract_Total] [decimal](9, 2) NOT NULL,
	[Summary_Level] [char](1) NOT NULL,
 CONSTRAINT [PK_AR_Credit_Authorization] PRIMARY KEY CLUSTERED 
(
	[Customer_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AR_Credit_Authorization] ADD  CONSTRAINT [DF__AR_Credit__Expec__6FD627B4]  DEFAULT (0) FOR [Expected_Open_Contract_Charges]
GO
ALTER TABLE [dbo].[AR_Credit_Authorization] ADD  CONSTRAINT [DF__AR_Credit__Daily__70CA4BED]  DEFAULT (0) FOR [Daily_Contract_Total]
GO
