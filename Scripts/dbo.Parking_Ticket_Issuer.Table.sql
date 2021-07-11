USE [GISData]
GO
/****** Object:  Table [dbo].[Parking_Ticket_Issuer]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parking_Ticket_Issuer](
	[Issuer_ID] [int] NOT NULL,
	[Company_Name] [varchar](80) NOT NULL,
	[Vendor_Code] [varchar](20) NOT NULL,
	[Address_1] [varchar](100) NULL,
	[Address_2] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[Province] [varchar](50) NULL,
	[Postal_Code] [varchar](20) NULL,
	[Telephone] [varchar](20) NULL,
	[Fax] [varchar](20) NULL,
	[Contact_Name] [varchar](30) NULL,
 CONSTRAINT [PK_Parking_Ticket_Issuer] PRIMARY KEY CLUSTERED 
(
	[Issuer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
