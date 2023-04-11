--------------------------------------------------------------------------------
-- Title         : 1-bit Comparator
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : oneBitComparator.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2003/05/17
-- Last modified : 2007/09/25
-------------------------------------------------------------------------------
-- Description : This file creates a 1-bit binary comparator as defined in the VHDL
--		 Synthesis lecture.  The architecture is done at the RTL
--		 abstraction level and the implementation is done in structural
--		 VHDL.
-------------------------------------------------------------------------------
-- Modification history :
-- 2003.05.17 	R. Abielmona		Creation
-- 2004.09.22 	R. Abielmona		Ported for CEG 3550
-- 2007.09.25 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitComparator IS
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT			: OUT	STD_LOGIC);
END oneBitComparator;

ARCHITECTURE rtl OF oneBitComparator IS
	SIGNAL int_GT1, int_GT2, int_LT1, int_LT2 : STD_LOGIC;
	SIGNAL int_GT, int_LT : STD_LOGIC;

BEGIN

	-- Concurrent Signal Assignment
	int_GT1 <= not(i_GTPrevious) and not(i_LTPrevious) and i_Ai and not(i_Bi);
	int_GT2 <= i_GTPrevious and not(i_LTPrevious);
	int_GT <= int_GT1 or int_GT2;
	int_LT1 <= not(i_GTPrevious) and not(i_LTPrevious) and not(i_Ai) and i_Bi;
	int_LT2 <= not(i_GTPrevious) and i_LTPrevious;
	int_LT <= int_LT1 or int_LT2;

	-- Output Driver
	o_GT <= int_GT;
	o_LT <= int_LT;

END rtl;
