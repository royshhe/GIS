USE [GISData]
GO
/****** Object:  Table [dbo].[Aeroplan_EFT_Detail]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aeroplan_EFT_Detail](
	[Detail_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_Creation_number] [int] NOT NULL,
	[Partner_Code] [varchar](3) NOT NULL,
	[Card_Number] [varchar](9) NOT NULL,
	[Alliance_Location_Name] [varchar](10) NULL,
	[Invoice_Number] [varchar](10) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Promo_Item_Code] [varchar](10) NULL,
	[MPC] [varchar](4) NULL,
	[Activity_Amount] [int] NULL,
	[Source_Identifier] [varchar](2) NULL,
	[Business_Transaction_ID] [int] NULL,
 CONSTRAINT [PK_Aeroplan_EFT_Detail] PRIMARY KEY CLUSTERED 
(
	[Detail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
