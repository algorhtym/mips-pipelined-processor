library ieee;
use ieee.std_logic_1164.all;

entity mux_5bit_2x1 is
    port (
        data_0, data_1 : in std_logic_vector(4 downto 0);
        sel : in std_logic;
        data_out : out std_logic_vector(4 downto 0)
    );
end entity;

architecture struc of mux_5bit_2x1 is

    signal i_data_out : std_logic_vector(4 downto 0);
    signal i_sel : std_logic;



begin

    i_data_out(4) <= (data_0(4) and not sel) or (data_1(4) and sel);
    i_data_out(3) <= (data_0(3) and not sel) or (data_1(3) and sel);
    i_data_out(2) <= (data_0(2) and not sel) or (data_1(2) and sel);
    i_data_out(1) <= (data_0(1) and not sel) or (data_1(1) and sel);
    i_data_out(0) <= (data_0(0) and not sel) or (data_1(0) and sel);

    data_out <= i_data_out;

    

end architecture;