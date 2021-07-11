USE [GISData]
GO
/****** Object:  Table [dbo].[Fraud_Credit_Cards]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fraud_Credit_Cards](
	[Credit_Card_Type_ID] [char](3) NULL,
	[Credit_Card_Number] [varchar](20) NOT NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Expiry] [char](5) NOT NULL,
 CONSTRAINT [PK_Fraud_Credit_Cards] PRIMARY KEY CLUSTERED 
(
	[Credit_Card_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
