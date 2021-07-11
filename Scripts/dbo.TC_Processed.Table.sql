USE [GISData]
GO
/****** Object:  Table [dbo].[TC_Processed]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TC_Processed](
	[Toll_Charge_ID] [int] IDENTITY(1,1) NOT NULL,
	[Toll_Charge_Date] [datetime] NOT NULL,
	[Licence_Plate] [varchar](10) NOT NULL,
	[Issuer] [varchar](10) NOT NULL,
 CONSTRAINT [PK_TC_Processed] PRIMARY KEY CLUSTERED 
(
	[Toll_Charge_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
