library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_1bit_8x1 is
    port (
        sel : in std_logic_vector(2 downto 0);
        data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic
    );
end entity mux_1bit_8x1;

architecture struc of mux_1bit_8x1 is

    -- signal dec
    signal i_sel : std_logic_vector(2 downto 0);
    --signal i_sel_not : std_logic_vector(2 downto 0);
    signal i_data_in : std_logic_vector(7 downto 0);
    signal i_and_out : std_logic_vector(7 downto 0);
    signal i_data_out : std_logic;
    

    -- component dec

begin

    -- component instantiations

    -- concurrent signal connections

    i_data_in <= data_in;
    i_sel <= sel;

    i_and_out(7) <= (i_data_in(7) and i_sel(2)) and (i_sel(1) and i_sel(0));
    i_and_out(6) <= (i_data_in(6) and i_sel(2)) and (i_sel(1) and not i_sel(0));
    i_and_out(5) <= (i_data_in(5) and i_sel(2)) and (not i_sel(1) and i_sel(0));
    i_and_out(4) <= (i_data_in(4) and i_sel(2)) and (not i_sel(1) and not i_sel(0));
    i_and_out(3) <= (i_data_in(3) and not i_sel(2)) and (i_sel(1) and i_sel(0));
    i_and_out(2) <= (i_data_in(2) and not i_sel(2)) and (i_sel(1) and not i_sel(0));
    i_and_out(1) <= (i_data_in(1) and not i_sel(2)) and (not i_sel(1) and i_sel(0));
    i_and_out(0) <= (i_data_in(0) and not i_sel(2)) and (not i_sel(1) and not i_sel(0));

    i_data_out <= (((i_and_out(7) or i_and_out(6)) or (i_and_out(5) or i_and_out(4))) or ((i_and_out(3) or i_and_out(2)) or (i_and_out(1) or i_and_out(0))));


    -- output driver
    data_out <= i_data_out;


end architecture;