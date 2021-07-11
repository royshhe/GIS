USE [GISData]
GO
/****** Object:  Table [dbo].[Drop_Off_History]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drop_Off_History](
	[Changed_On] [datetime] NOT NULL,
	[Contract_Number] [int] NOT NULL,
	[Changed_By] [varchar](20) NOT NULL,
	[Drop_Off_Location] [smallint] NOT NULL,
	[Drop_Off_On] [datetime] NOT NULL,
	[Reason] [varchar](255) NULL,
 CONSTRAINT [PK_Drop_Off_History] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Changed_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Drop_Off_History]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract09] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Drop_Off_History] CHECK CONSTRAINT [FK_Contract09]
GO
