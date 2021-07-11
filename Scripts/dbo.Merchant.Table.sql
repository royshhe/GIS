USE [GISData]
GO
/****** Object:  Table [dbo].[Merchant]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Merchant](
	[Merchant_ID] [varchar](20) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Credit_Card_Type_ID] [char](3) NOT NULL,
 CONSTRAINT [PK_Merchant] PRIMARY KEY CLUSTERED 
(
	[Merchant_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Merchant]  WITH NOCHECK ADD  CONSTRAINT [FK_Credit_Card_Type5] FOREIGN KEY([Credit_Card_Type_ID])
REFERENCES [dbo].[Credit_Card_Type] ([Credit_Card_Type_ID])
GO
ALTER TABLE [dbo].[Merchant] CHECK CONSTRAINT [FK_Credit_Card_Type5]
GO
ALTER TABLE [dbo].[Merchant]  WITH NOCHECK ADD  CONSTRAINT [FK_Location26] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Merchant] CHECK CONSTRAINT [FK_Location26]
GO
