USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_GL]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_GL](
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[GL_Revenue_Account] [varchar](32) NOT NULL,
 CONSTRAINT [PK_Optional_Extra_GL] PRIMARY KEY CLUSTERED 
(
	[Optional_Extra_ID] ASC,
	[Vehicle_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Optional_Extra_GL]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra09] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Optional_Extra_GL] CHECK CONSTRAINT [FK_Optional_Extra09]
GO
ALTER TABLE [dbo].[Optional_Extra_GL]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Type3] FOREIGN KEY([Vehicle_Type_ID])
REFERENCES [dbo].[Vehicle_Type] ([Vehicle_Type_ID])
GO
ALTER TABLE [dbo].[Optional_Extra_GL] CHECK CONSTRAINT [FK_Vehicle_Type3]
GO
