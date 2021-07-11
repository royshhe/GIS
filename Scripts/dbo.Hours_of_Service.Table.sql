USE [GISData]
GO
/****** Object:  Table [dbo].[Hours_of_Service]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hours_of_Service](
	[Location_ID] [smallint] NOT NULL,
	[Day_of_Week] [tinyint] NOT NULL,
	[Opens_At] [char](5) NOT NULL,
	[Closes_At] [char](5) NOT NULL,
 CONSTRAINT [PK_Hours_of_Service] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC,
	[Day_of_Week] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Hours_of_Service]  WITH NOCHECK ADD  CONSTRAINT [FK_Location14] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Hours_of_Service] CHECK CONSTRAINT [FK_Location14]
GO
