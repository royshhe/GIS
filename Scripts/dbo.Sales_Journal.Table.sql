USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Journal]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Journal](
	[Business_Transaction_ID] [int] NOT NULL,
	[Sequence] [tinyint] NOT NULL,
	[GL_Account] [varchar](32) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_Sales_Journal] PRIMARY KEY CLUSTERED 
(
	[Business_Transaction_ID] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Journal]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Journ_Business_Tr] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Sales_Journal] CHECK CONSTRAINT [FK_Sales_Journ_Business_Tr]
GO
