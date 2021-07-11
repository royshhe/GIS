USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_Price]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_Price](
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Optional_Extra_Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Rental_Calendar_Day] [char](8) NOT NULL,
	[Daily_Rate] [decimal](7, 2) NOT NULL,
	[Weekly_Rate] [decimal](7, 2) NOT NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[HST2_Exempt] [bit] NULL,
 CONSTRAINT [PK_Optional_Extra_Price] PRIMARY KEY CLUSTERED 
(
	[Optional_Extra_ID] ASC,
	[Optional_Extra_Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Optional_Extra_Price]  WITH NOCHECK ADD  CONSTRAINT [FK_Optional_Extra04] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Optional_Extra_Price] CHECK CONSTRAINT [FK_Optional_Extra04]
GO
