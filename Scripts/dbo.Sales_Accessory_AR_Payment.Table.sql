USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_AR_Payment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_AR_Payment](
	[Sales_Contract_Number] [int] NOT NULL,
	[Customer_Code] [varchar](12) NOT NULL,
	[PO_Number] [varchar](20) NULL,
 CONSTRAINT [PK_Sales_Accessory_AR_Payment] PRIMARY KEY CLUSTERED 
(
	[Sales_Contract_Number] ASC,
	[Customer_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
