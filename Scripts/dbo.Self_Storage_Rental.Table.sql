USE [GISData]
GO
/****** Object:  Table [dbo].[Self_Storage_Rental]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Self_Storage_Rental](
	[Transaction_ID] [int] IDENTITY(1,1) NOT NULL,
	[First_Name] [varchar](50) NULL,
	[Last_Name] [varchar](50) NULL,
	[Unit_Number] [varchar](20) NULL,
	[Site_Name] [varchar](80) NULL,
	[Location] [varchar](30) NULL,
	[CCType] [varchar](20) NULL,
	[CCToken] [varchar](50) NULL,
	[Expiry_Date] [varchar](20) NULL,
	[Amount] [decimal](9, 2) NULL,
	[Paid_Through_Date] [datetime] NULL,
	[Processed] [bit] NULL,
	[Business_Transaction_ID] [int] NULL,
 CONSTRAINT [PK_Self_Storage_Rental] PRIMARY KEY CLUSTERED 
(
	[Transaction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
