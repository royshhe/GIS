USE [GISData]
GO
/****** Object:  Table [dbo].[IB_Vouchers]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IB_Vouchers](
	[Vendor_No] [nvarchar](20) NOT NULL,
	[Invoice_Type] [nvarchar](20) NOT NULL,
	[Due_Date] [smalldatetime] NOT NULL,
	[Foreign_Num] [nvarchar](30) NOT NULL,
	[Contract_Number] [int] NOT NULL,
	[Due_Amount] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_IB_Vouchers] PRIMARY KEY CLUSTERED 
(
	[Vendor_No] ASC,
	[Invoice_Type] ASC,
	[Due_Date] ASC,
	[Foreign_Num] ASC,
	[Contract_Number] ASC,
	[Due_Amount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
