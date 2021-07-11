USE [GISData]
GO
/****** Object:  Table [dbo].[Insurance_Replacement_Renter_History]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insurance_Replacement_Renter_History](
	[Contract_Number] [int] NOT NULL,
	[Vehicle_Licence_Plate] [varchar](10) NULL,
	[Claim_Number] [varchar](50) NULL,
	[Accident_Type] [varchar](10) NULL,
	[Shop_Name] [varchar](50) NULL,
	[Date_In_Shop] [datetime] NULL,
	[Last_Change_On] [datetime] NOT NULL,
	[Last_Change_By] [varchar](20) NULL,
 CONSTRAINT [PK_Insurance_Replacement_Renter_Hostory] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Last_Change_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
