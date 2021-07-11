USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxMsg]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxMsg](
	[message_number] [int] NOT NULL,
	[message_short] [char](30) NULL,
	[message_type] [int] NULL,
	[message_description] [char](100) NULL,
	[message_apply_to] [char](20) NULL,
	[vsi_result_code] [int] NULL,
	[query_flag] [int] NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_autofaxmsg] PRIMARY KEY CLUSTERED 
(
	[message_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoFaxMsg]  WITH CHECK ADD  CONSTRAINT [FK_msg_msgtype_id] FOREIGN KEY([message_type])
REFERENCES [dbo].[AutoFaxMsgType] ([type_id])
GO
ALTER TABLE [dbo].[AutoFaxMsg] CHECK CONSTRAINT [FK_msg_msgtype_id]
GO
