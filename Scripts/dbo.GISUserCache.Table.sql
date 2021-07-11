USE [GISData]
GO
/****** Object:  Table [dbo].[GISUserCache]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISUserCache](
	[user_id] [char](20) NOT NULL,
	[user_hash] [char](36) NOT NULL,
	[report_hash] [char](36) NOT NULL,
	[last_screen_id] [char](50) NULL,
	[last_updated_on] [datetime] NOT NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_GISUserCache] PRIMARY KEY NONCLUSTERED 
(
	[user_hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GISUserCache]  WITH NOCHECK ADD  CONSTRAINT [FK_GISUserCache_GISUsers] FOREIGN KEY([user_id])
REFERENCES [dbo].[GISUsers] ([user_id])
GO
ALTER TABLE [dbo].[GISUserCache] CHECK CONSTRAINT [FK_GISUserCache_GISUsers]
GO
