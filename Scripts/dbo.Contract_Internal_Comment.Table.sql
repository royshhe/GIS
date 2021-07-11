USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Internal_Comment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Internal_Comment](
	[Contract_Number] [int] NOT NULL,
	[Logged_On] [datetime] NOT NULL,
	[Logged_By] [varchar](20) NOT NULL,
	[Comments] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Contract_Internal_Comment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Logged_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Internal_Comment]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract10] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Internal_Comment] CHECK CONSTRAINT [FK_Contract10]
GO
