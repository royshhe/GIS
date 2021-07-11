USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[Mod10Check]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Mod10Check] (
    
     @Target varchar(20) -- Number string to validate

/* Validates that a sequence of digits satisfies the Luhn
* validation formula.  It's also know as MOD 10. The full
* description is in the ANSI X4.13 specification. The Luhn
* formula is used to validate credit card numbers, Canadian
* social security numbers and many other financial services
* numbers.  Another common formula is Mod 11. 
*
* Dashes are removed before the number is checked.  They're
* removed from anywhere in the number so if they have to be
* in certain positions, the number should be pre-validated
* for the correct positions.  False is returned for non-numerics,
* null arguments or zero length arguments.
*
* Here's a definition of the algorithm from webopedia:
* 1) Starting with the second to last digit and moving left, 
* double the value of all the alternating digits. 
* 2) Starting from the left, take all the unaffected digits 
* and add them to the results of all the individual digits 
* from step 1. If the results from any of the numbers from 
* step 1 are double digits, make sure to add the two numbers 
* first (i.e. 18 would yield 1+8). 
* 3) The total from step 2 must end in zero for the credit-card 
* number to be valid. 
*
* Example:
select CASE WHEN 1=dbo.udf_Bank_IsLuhn ('2323-2005-7766-3554') 
        then 'Valid' ELSE 'Invalid' END
*
* Test:
SELECT CASE WHEN 1=dbo.udf_Bank_IsLuhn ('2323-2005-7766-3554') 
        then 'Worked' ELSE 'ERROR' END
SELECT CASE WHEN 0=dbo.udf_Bank_IsLuhn ('3323-2005-7766-3554') 
        then 'Worked' ELSE 'ERROR' END
SELECT CASE WHEN 0=dbo.udf_Bank_IsLuhn ('2323-2D05-7766-3554') 
        then 'Worked' ELSE 'ERROR' END
SELECT CASE WHEN 1=dbo.udf_Bank_IsLuhn ('4111-1111-1111-1111') 
        then 'Worked' ELSE 'ERROR' END -- Visa
SELECT CASE WHEN 1=dbo.udf_Bank_IsLuhn ('3400-0000-0000-009') 
        then 'Worked' ELSE 'ERROR' END -- Amex
SELECT CASE WHEN 1=dbo.udf_Bank_IsLuhn ('3400-0000-0000-009') 
        then 'Worked' ELSE 'ERROR' END -- Amex
SELECT CASE WHEN 1=dbo.udf_Bank_IsLuhn ('6011-0000-0000-0004') 
        then 'Worked' ELSE 'ERROR' END -- Discover
SELECT CASE WHEN 1=dbo.udf_Bank_IsLuhn ('5500-0000-0000-0004') 
        then 'Worked' ELSE 'ERROR' END -- Master card
*
* © Copyright 2004 Andrew Novick http://www.NovickSoftware.com
* You may use this function in any of your SQL Server databases
* including databases that you sell, so long as they contain 
* other unrelated database objects. You may not publish this 
* UDF either in print or electronically.
* Published as T-SQL UDF of the Week  Vol 2 #47 11/30/04
http://www.NovickSoftware.com/UDFofWeek/UDFofWeek.htm
****************************************************************/

) RETURNS BIT

AS BEGIN 
    
DECLARE @pos int
      , @a int
      , @b int
      , @chrVal int

-- Handle Null, zero length, or non-numeric input as false
IF @Target IS NULL OR LEN(@Target)=0 RETURN 0

-- remove any dashes from the number.
SET @Target = REPLACE(@Target, '-', '')

IF 0=ISNUMERIC(@Target) RETURN 0 -- Must be numeric

SELECT @a = 0, @b = 0, @pos=len(@Target) -- Start from end

WHILE @pos>0 BEGIN -- Until the beginning

	IF @pos>1 BEGIN -- Not at the 1st character
	
 	    SET @ChrVal= (ASCII(SUBSTRING(@Target,@pos-1,1))-48)*2
        SET @a = @A + @chrVal 
                 + CASE WHEN @ChrVal>9 THEN -9 ELSE 0 END
	END

	SET @b= @b + (ASCII(SUBSTRING(@Target,@pos,1))-48)
	SET @pos = @pos - 2
END -- WHILE

-- True if @A + @B mod 10 is zero
RETURN CASE WHEN 0 = (@a + @b) % 10 THEN 1 ELSE 0 END 

END


GO
