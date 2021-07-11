USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Type]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Type](
	[Credit_Card_Type_ID] [char](3) NOT NULL,
	[Credit_Card_Type] [varchar](20) NOT NULL,
	[AR_Payment_Account] [varchar](12) NOT NULL,
	[AR_Ticket_Account] [varchar](12) NOT NULL,
	[AR_Claim_Account] [varchar](12) NOT NULL,
	[Floor_Limit] [decimal](9, 2) NOT NULL,
	[Electronic_Authorization] [bit] NOT NULL,
	[Authorization_Phone_Number] [varchar](31) NOT NULL,
	[Maestro_Code] [char](2) NULL,
	[Expiry_Required] [bit] NOT NULL,
	[Eigen_Code] [char](2) NULL,
	[Mod_10_Check] [bit] NOT NULL,
	[DeleteFlag] [bit] NULL,
	[Online_Mart_Code] [char](2) NULL,
	[Eigen_Card_Code] [varchar](15) NULL,
	[Mask_Required] [bit] NULL,
 CONSTRAINT [PK_Credit_Card_Type] PRIMARY KEY CLUSTERED 
(
	[Credit_Card_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Credit_Card_Type1] UNIQUE NONCLUSTERED 
(
	[Credit_Card_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card_Type] ADD  CONSTRAINT [DF__Credit_Ca__Elect__7797450D]  DEFAULT (0) FOR [Electronic_Authorization]
GO
ALTER TABLE [dbo].[Credit_Card_Type] ADD  CONSTRAINT [DF_Credit_Card_Expiry_Requ]  DEFAULT (1) FOR [Expiry_Required]
GO
ALTER TABLE [dbo].[Credit_Card_Type] ADD  CONSTRAINT [DF_Credit_Card_Type_Mod_10_Check]  DEFAULT (0) FOR [Mod_10_Check]
GO
ALTER TABLE [dbo].[Credit_Card_Type] ADD  CONSTRAINT [DF_Credit_Card_Type_DeleteFlag]  DEFAULT (0) FOR [DeleteFlag]
GO
