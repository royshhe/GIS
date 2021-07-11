USE [GISData]
GO
/****** Object:  Table [dbo].[IB_apapay]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IB_apapay](
	[Vender_No] [nvarchar](20) NULL,
	[Invoice_Type] [nvarchar](20) NULL,
	[Doc_Number] [nvarchar](50) NOT NULL,
	[Applied_Date] [smalldatetime] NOT NULL,
	[Due_Date] [smalldatetime] NOT NULL,
	[Due_Current] [decimal](9, 2) NULL,
	[Due_1TO30] [decimal](9, 2) NULL,
	[Due_31To60] [decimal](9, 2) NULL,
	[Due_61TO90] [decimal](9, 2) NULL,
	[Due_Over90] [decimal](9, 2) NULL,
	[Overdue] [decimal](9, 2) NULL,
	[Payables] [decimal](9, 2) NULL,
 CONSTRAINT [PK_IB_apapay] PRIMARY KEY CLUSTERED 
(
	[Doc_Number] ASC,
	[Applied_Date] ASC,
	[Due_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
