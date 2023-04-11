library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8bit_8x1 is
    port (
        sel : in std_logic_vector(2 downto 0);
        data_in0 : in std_logic_vector(7 downto 0);
        data_in1 : in std_logic_vector(7 downto 0);
        data_in2 : in std_logic_vector(7 downto 0);
        data_in3 : in std_logic_vector(7 downto 0);
        data_in4 : in std_logic_vector(7 downto 0);
        data_in5 : in std_logic_vector(7 downto 0);
        data_in6 : in std_logic_vector(7 downto 0);
        data_in7 : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture struc of mux_8bit_8x1 is
    -- signal dec
    signal i_data_in0, i_data_in1, i_data_in2, i_data_in3, i_data_in4, i_data_in5, i_data_in6, i_data_in7 : std_logic_vector(7 downto 0);
    signal i_sel : std_logic_vector(2 downto 0);
    signal i_data_out : std_logic_vector(7 downto 0);
    signal i_mux_in0, i_mux_in1, i_mux_in2, i_mux_in3, i_mux_in4, i_mux_in5, i_mux_in6, i_mux_in7 : std_logic_vector(7 downto 0);
    
    -- component dec

    component mux_1bit_8x1 is
        port (
            sel : in std_logic_vector(2 downto 0);
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic
        );
    end component;


begin

    -- component instantiations

    -- bit 7
    bit7 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in7,
        data_out => i_data_out(7)
    );
    -- bit 6
    bit6 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in6,
        data_out => i_data_out(6)
    );

    -- bit 5
    bit5 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in5,
        data_out => i_data_out(5)
    );

    -- bit 4
    bit4 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in4,
        data_out => i_data_out(4)
    );

    -- bit 3
    bit3 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in3,
        data_out => i_data_out(3)
    );

    -- bit 2
    bit2 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in2,
        data_out => i_data_out(2)
    );

    -- bit 1
    bit1 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in1,
        data_out => i_data_out(1)
    );

    -- bit 0
    bit0 : mux_1bit_8x1 port map (
        sel => i_sel,
        data_in => i_mux_in0,
        data_out => i_data_out(0)
    );





    -- concurrent signal connections

    i_mux_in7 <= i_data_in7(7) & i_data_in6(7) & i_data_in5(7) & i_data_in4(7) & i_data_in3(7) & i_data_in2(7) & i_data_in1(7) & i_data_in0(7);
    i_mux_in6 <= i_data_in7(6) & i_data_in6(6) & i_data_in5(6) & i_data_in4(6) & i_data_in3(6) & i_data_in2(6) & i_data_in1(6) & i_data_in0(6);
    i_mux_in5 <= i_data_in7(5) & i_data_in6(5) & i_data_in5(5) & i_data_in4(5) & i_data_in3(5) & i_data_in2(5) & i_data_in1(5) & i_data_in0(5);
    i_mux_in4 <= i_data_in7(4) & i_data_in6(4) & i_data_in5(4) & i_data_in4(4) & i_data_in3(4) & i_data_in2(4) & i_data_in1(4) & i_data_in0(4);
    i_mux_in3 <= i_data_in7(3) & i_data_in6(3) & i_data_in5(3) & i_data_in4(3) & i_data_in3(3) & i_data_in2(3) & i_data_in1(3) & i_data_in0(3);
    i_mux_in2 <= i_data_in7(2) & i_data_in6(2) & i_data_in5(2) & i_data_in4(2) & i_data_in3(2) & i_data_in2(2) & i_data_in1(2) & i_data_in0(2);
    i_mux_in1 <= i_data_in7(1) & i_data_in6(1) & i_data_in5(1) & i_data_in4(1) & i_data_in3(1) & i_data_in2(1) & i_data_in1(1) & i_data_in0(1);
    i_mux_in0 <= i_data_in7(0) & i_data_in6(0) & i_data_in5(0) & i_data_in4(0) & i_data_in3(0) & i_data_in2(0) & i_data_in1(0) & i_data_in0(0);
    
    i_data_in7 <= data_in7;
    i_data_in6 <= data_in6;
    i_data_in5 <= data_in5;
    i_data_in4 <= data_in4;
    i_data_in3 <= data_in3;
    i_data_in2 <= data_in2;
    i_data_in1 <= data_in1;
    i_data_in0 <= data_in0;

    i_sel <= sel;


    -- output driver
    data_out <= i_data_out;

    

end architecture;