USE [GISData]
GO
/****** Object:  Table [dbo].[Cash_Payment]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cash_Payment](
	[Contract_Number] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Cash_Payment_Type] [varchar](20) NOT NULL,
	[Identification_Number] [varchar](20) NULL,
	[Foreign_Currency_Amt_Collected] [decimal](9, 2) NOT NULL,
	[Exchange_Rate] [decimal](9, 4) NULL,
	[Authorization_Number] [varchar](12) NULL,
	[Swiped_Flag] [bit] NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Trx_Receipt_Ref_Num] [char](20) NULL,
	[Trx_ISO_Response_Code] [char](2) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Cash_Payment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
