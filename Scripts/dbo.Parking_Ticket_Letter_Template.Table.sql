USE [GISData]
GO
/****** Object:  Table [dbo].[Parking_Ticket_Letter_Template]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parking_Ticket_Letter_Template](
	[Template_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](20) NOT NULL,
	[LetterName] [varchar](50) NOT NULL,
	[Lettter_Body] [varchar](8000) NULL,
	[Billing_Method] [varchar](20) NULL,
	[Contract_Status] [varchar](10) NULL,
 CONSTRAINT [PK_Parking_Ticket_Letter_Template_1] PRIMARY KEY CLUSTERED 
(
	[Template_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
