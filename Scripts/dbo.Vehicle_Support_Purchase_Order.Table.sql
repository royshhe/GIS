USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Support_Purchase_Order]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Support_Purchase_Order](
	[Vehicle_Support_Incident_Seq] [int] NOT NULL,
	[PO_Number] [varchar](15) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[GST] [decimal](9, 2) NULL,
	[PST] [decimal](9, 2) NULL,
	[Description] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Vehicle_Support_Purchase_Or] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Support_Incident_Seq] ASC,
	[PO_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Support_Purchase_Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident05] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Vehicle_Support_Purchase_Order] CHECK CONSTRAINT [FK_Vehicle_Support_Incident05]
GO
