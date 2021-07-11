USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Support_Comment]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Support_Comment](
	[Vehicle_Support_Incident_Seq] [int] NOT NULL,
	[Logged_On] [datetime] NOT NULL,
	[Logged_By] [varchar](25) NOT NULL,
	[Comment] [varchar](255) NOT NULL,
	[Comment_Seq] [int] NOT NULL,
 CONSTRAINT [PK_Vehicle_Support_Comment] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Support_Incident_Seq] ASC,
	[Comment_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Support_Comment]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident04] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Vehicle_Support_Comment] CHECK CONSTRAINT [FK_Vehicle_Support_Incident04]
GO
