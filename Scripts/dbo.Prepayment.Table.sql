USE [GISData]
GO
/****** Object:  Table [dbo].[Prepayment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prepayment](
	[Contract_Number] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Payment_Type] [varchar](20) NOT NULL,
	[Issuer_ID] [varchar](50) NOT NULL,
	[PP_Number] [varchar](25) NULL,
	[Foreign_Currency_Amt_Collected] [decimal](9, 2) NOT NULL,
	[Exchange_Rate] [decimal](9, 4) NULL,
 CONSTRAINT [PK_Prepayment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sequence] ASC,
	[Payment_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
