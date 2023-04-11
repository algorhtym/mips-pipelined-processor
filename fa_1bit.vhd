LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY fa_1bit IS

PORT(
   Ci : IN STD_LOGIC;
   Xi, Yi : IN STD_LOGIC;
   Si, Ci_1 : OUT STD_LOGIC);
END fa_1bit;

ARCHITECTURE rtl OF fa_1bit IS
    SIGNAL CarryOut1, CarryOut2, CarryOut3, CarryOut4:
STD_LOGIC;
BEGIN
    CarryOut1 <= Xi xor Yi;
    CarryOut2 <= Xi and Yi;
    CarryOut3 <= CarryOut1 and Ci;
    

    Ci_1 <= CarryOut3 or CarryOut2;
    Si <= CarryOut1 xor Ci;
END rtl;