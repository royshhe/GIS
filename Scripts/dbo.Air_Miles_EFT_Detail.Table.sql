USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_EFT_Detail]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_EFT_Detail](
	[Detail_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_Creation_number] [int] NOT NULL,
	[Invoice_Number] [varchar](7) NOT NULL,
	[Business_Transaction_ID] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Customer_Number] [varchar](4) NULL,
	[Store_Number] [varchar](4) NULL,
	[Terminal_Number] [varchar](4) NULL,
	[Transaction_Type] [varchar](2) NULL,
	[Card_Number] [varchar](11) NULL,
	[AMTM_Tran_Type] [varchar](2) NULL,
	[Entry_Mode] [varchar](1) NULL,
	[Transaction_Time] [varchar](4) NULL,
	[Transaction_Date] [varchar](6) NULL,
	[Payment_Type] [varchar](1) NULL,
	[Sponsor_Number] [varchar](4) NULL,
	[Base_Offer_Code] [varchar](8) NULL,
	[Sales_Amount] [decimal](9, 2) NULL,
	[Standard_Mile_Points] [int] NULL,
	[Multiply_Factor] [int] NULL,
	[Multiplier_Miles] [int] NULL,
	[Bonus_Offer_Code] [varchar](8) NULL,
	[Offer_Quantity] [int] NULL,
	[Bonus_Miles] [int] NULL,
	[Offer_Type] [int] NULL,
 CONSTRAINT [PK_Air_Miles_EFT_Detail] PRIMARY KEY CLUSTERED 
(
	[Detail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
