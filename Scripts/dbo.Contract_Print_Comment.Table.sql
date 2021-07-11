USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Print_Comment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Print_Comment](
	[Contract_Number] [int] NOT NULL,
	[Standard_Print_Comment_id] [smallint] NOT NULL,
 CONSTRAINT [PK_Contract_Print_Comment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Standard_Print_Comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Print_Comment]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract11] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Print_Comment] CHECK CONSTRAINT [FK_Contract11]
GO
