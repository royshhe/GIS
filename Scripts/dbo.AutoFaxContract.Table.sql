USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxContract]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxContract](
	[control_ID] [int] IDENTITY(1,1) NOT NULL,
	[Contract_number] [int] NOT NULL,
	[copy_sequence] [int] NOT NULL,
	[contract_rbr_date] [datetime] NOT NULL,
	[contract_status] [char](2) NOT NULL,
	[process_date] [datetime] NOT NULL,
	[process_status] [int] NOT NULL,
	[fax_type] [int] NOT NULL,
	[try_times] [int] NOT NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_autofaxcontract] PRIMARY KEY CLUSTERED 
(
	[control_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_number_rbr] UNIQUE NONCLUSTERED 
(
	[Contract_number] ASC,
	[contract_rbr_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoFaxContract]  WITH CHECK ADD  CONSTRAINT [FK_faxtype] FOREIGN KEY([fax_type])
REFERENCES [dbo].[AutoFaxType] ([type_ID])
GO
ALTER TABLE [dbo].[AutoFaxContract] CHECK CONSTRAINT [FK_faxtype]
GO
ALTER TABLE [dbo].[AutoFaxContract]  WITH CHECK ADD  CONSTRAINT [FK_processstatus] FOREIGN KEY([process_status])
REFERENCES [dbo].[AutoFaxMsg] ([message_number])
GO
ALTER TABLE [dbo].[AutoFaxContract] CHECK CONSTRAINT [FK_processstatus]
GO
