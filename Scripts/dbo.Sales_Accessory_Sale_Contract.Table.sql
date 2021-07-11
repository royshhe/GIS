USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_Sale_Contract]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_Sale_Contract](
	[Sales_Contract_Number] [int] IDENTITY(1,1) NOT NULL,
	[Sold_At_Location_ID] [smallint] NOT NULL,
	[Sales_Date_Time] [datetime] NOT NULL,
	[Sold_By] [varchar](25) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Phone_Number] [varchar](31) NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[Province] [varchar](25) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Country] [varchar](25) NULL,
	[Refunded_Contract_No] [int] NULL,
	[Refund_Reason] [varchar](255) NULL,
 CONSTRAINT [PK_Sales_Accessory_Sale_Contrt] PRIMARY KEY CLUSTERED 
(
	[Sales_Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Location22] FOREIGN KEY([Sold_At_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Contract] CHECK CONSTRAINT [FK_Location22]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Contract]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory_Sale_Contract2] FOREIGN KEY([Refunded_Contract_No])
REFERENCES [dbo].[Sales_Accessory_Sale_Contract] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Contract] CHECK CONSTRAINT [FK_Sales_Accessory_Sale_Contract2]
GO
