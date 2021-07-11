USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchConResv]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SearchConResv    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.SearchConResv    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.SearchConResv    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.SearchConResv    Script Date: 11/23/98 3:55:34 PM ******/

/*
NP - Aug 12 1999 - Removed the condition where status in ('a', 'n')
rhe- aug 20 2005  - fix for db compability level 80
rhe - upgrade to ms sql 2008
exec SearchConResv '', '', 'LUI', ''

*/
CREATE PROCEDURE [dbo].[SearchConResv]
	@ConfirmNum Varchar(20),
	@ForeignConfirmNum Varchar(20),
	@LastName Varchar(25),
	@FirstName Varchar(25)
AS
	IF @ConfirmNum = "" 		SELECT @ConfirmNum = NULL
	IF @ForeignConfirmNum = "" 	SELECT @ForeignConfirmNum = NULL
	--IF @LastName = "" 		SELECT @LastName = NULL
	--IF @FirstName = "" 		SELECT @FirstName = NULL
	
	IF NOT @ConfirmNum IS NULL
		SELECT	A.Confirmation_Number, A.Last_Name, A.First_Name,
			Convert(Varchar(17), A.Pick_Up_On, 113), B.Location,
			C.Vehicle_Class_Name, D.Value


		FROM	Reservation A
	       Inner Join 	Lookup_Table D
		   On A.Status = D.Code
			Left Join 	Location B
			On A.Pick_Up_Location_ID= B.Location_ID
			Left Join 	Vehicle_Class C
			On A.Vehicle_Class_Code = C.Vehicle_Class_Code
		
--	FROM	Lookup_Table D,
--			Reservation A,
--			Location B,
--			Vehicle_Class C
		WHERE	A.Confirmation_Number = Convert(Int, @ConfirmNum)
--		AND	A.Status = D.Code
		AND	D.Category = 'Reservation Status'
--		AND 	A.Pick_Up_Location_ID *= B.Location_ID
--		AND 	A.Vehicle_Class_Code *= C.Vehicle_Class_Code
		ORDER BY A.Last_Name, A.First_Name, A.Pick_Up_On
	ELSE IF NOT @ForeignConfirmNum IS NULL
		SELECT	A.Confirmation_Number, A.Last_Name, A.First_Name,
			Convert(Varchar(17), A.Pick_Up_On, 113), B.Location,
			C.Vehicle_Class_Name, D.Value


		FROM	Reservation A
	       Inner Join 	Lookup_Table D
		   On A.Status = D.Code
			Left Join 	Location B
			On A.Pick_Up_Location_ID= B.Location_ID
			Left Join 	Vehicle_Class C
			On A.Vehicle_Class_Code = C.Vehicle_Class_Code

--		FROM	Lookup_Table D,
--			Reservation A,
--			Location B,
--			Vehicle_Class C

		WHERE	A.Foreign_Confirm_Number = @ForeignConfirmNum
--		AND	A.Status = D.Code
		AND	D.Category = 'Reservation Status'
--		AND 	A.Pick_Up_Location_ID *= B.Location_ID
--		AND 	A.Vehicle_Class_Code *= C.Vehicle_Class_Code
		ORDER BY A.Last_Name, A.First_Name, A.Pick_Up_On
	ELSE
		SELECT	Top 100 A.Confirmation_Number, A.Last_Name, A.First_Name,
			Convert(Varchar(17), A.Pick_Up_On, 113), B.Location,
			C.Vehicle_Class_Name, D.Value


		FROM	Reservation A
	       Inner Join 	Lookup_Table D
		   On A.Status = D.Code
			Left Join 	Location B
			On A.Pick_Up_Location_ID= B.Location_ID
			Left Join 	Vehicle_Class C
			On A.Vehicle_Class_Code = C.Vehicle_Class_Code


--		FROM	Lookup_Table D,
--			Reservation A,
--			Location B,
--			Vehicle_Class C
		WHERE	
--		A.Status = D.Code AND	
		D.Category = 'Reservation Status'
		AND	A.Last_Name LIKE @LastName + '%'
		AND A.Status='A'

		AND	A.First_Name LIKE @FirstName + '%'
--		AND 	A.Pick_Up_Location_ID *= B.Location_ID
--		AND 	A.Vehicle_Class_Code *= C.Vehicle_Class_Code
		ORDER BY A.Last_Name, A.First_Name, A.Pick_Up_On
	RETURN @@ROWCOUNT
GO
