USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Buyer]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Buyer](
	[Customer_Code] [char](12) NOT NULL,
	[Manufacturer_ID] [smallint] NULL,
	[Buyer_Name] [varchar](50) NULL,
	[PSTable] [bit] NULL,
	[Address] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[Province] [varchar](50) NULL,
	[Postal_Code] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[Phone_Number] [varchar](31) NULL,
	[Fax_Number] [varchar](50) NULL,
	[OldName] [varchar](50) NULL,
 CONSTRAINT [PK_FA_Buyer] PRIMARY KEY CLUSTERED 
(
	[Customer_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
