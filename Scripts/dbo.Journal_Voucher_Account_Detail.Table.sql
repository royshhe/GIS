USE [GISData]
GO
/****** Object:  Table [dbo].[Journal_Voucher_Account_Detail]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Voucher_Account_Detail](
	[RBR_Date] [datetime] NOT NULL,
	[GL_Account] [varchar](32) NOT NULL,
	[Total_Amount] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_Journal_Voucher_Account_Detail] PRIMARY KEY CLUSTERED 
(
	[RBR_Date] ASC,
	[GL_Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
