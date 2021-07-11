USE [GISData]
GO
/****** Object:  Table [dbo].[Employee_Damage]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Damage](
	[Damage_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Incident_Date] [datetime] NULL,
	[Claim_File_number] [int] NULL,
	[Contract_Number] [int] NULL,
	[Unit_Number] [int] NULL,
	[Damage_Amount] [decimal](11, 2) NULL,
	[Liability] [varchar](50) NULL,
	[Damage_Type] [char](2) NULL,
 CONSTRAINT [PK_Employee_Damage] PRIMARY KEY CLUSTERED 
(
	[Damage_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
