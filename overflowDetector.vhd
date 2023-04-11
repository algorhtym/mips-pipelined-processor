library ieee;
use ieee.std_logic_1164.all;
entity overflowDetector is
    port(
        i_bInvert : in std_logic;
        i_a : in std_logic;
        i_muxOut : in std_logic;
        i_addOut : in std_logic;
        o_overflow : out std_logic
    );
end entity overflowDetector;

architecture rtl of overflowDetector is

    signal int_andOut1, int_andOut2, int_andOut3, int_andOut4 : std_logic;
    begin
    int_andOut1 <= not(i_bInvert) and not(i_a) and not(i_muxOut) and i_addOut;
    int_andOut2 <= not(i_bInvert) and i_a and i_muxOut and not(i_addOut);
    int_andOut3 <= i_bInvert and not(i_a) and i_muxOut and i_addOut;
    int_andOut4 <= i_bInvert and i_a and not(i_muxOut) and not(i_addOut);
    -- Output driver
    o_overflow <= int_andOut1 or int_andOut2 or int_andOut3 or int_andOut4;
end architecture rtl;