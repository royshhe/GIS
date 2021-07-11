USE [GISData]
GO
/****** Object:  Table [dbo].[Included_Sales_Accessory]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Included_Sales_Accessory](
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Included_Amount] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_Included_Sales_Accessory] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Sales_Accessory_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Included_Sales_Accessory1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Included_Sales_Accessory1] ON [dbo].[Included_Sales_Accessory]
(
	[Rate_ID] ASC,
	[Termination_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Included_Sales_Accessory]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory1] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Included_Sales_Accessory] CHECK CONSTRAINT [FK_Sales_Accessory1]
GO
