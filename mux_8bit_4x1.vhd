library ieee;
use ieee.std_logic_1164.all;

entity mux_8bit_4x1 is
    port (
        data_0, data_1, data_2, data_3 : in std_logic_vector(7 downto 0);
        sel : in std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of mux_8bit_4x1 is

    -- signal declarations
    signal i_mux1_out, i_mux2_out, i_mux3_out : std_logic_vector(7 downto 0);



    -- component declarations

    component mux_8bit_2x1 is
        port (
            data_0, data_1 : in std_logic_vector(7 downto 0);
            sel : in std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- component instantiations

    mux1: mux_8bit_2x1 port map (
        data_0 => data_0, data_1 => data_1,
        sel =>sel(0),
        data_out => i_mux1_out
    );

    mux2: mux_8bit_2x1 port map (
        data_0 => data_2, data_1 => data_3,
        sel =>sel(0),
        data_out => i_mux2_out
    );

    mux3: mux_8bit_2x1 port map (
        data_0 => i_mux1_out, data_1 => i_mux2_out,
        sel =>sel(1),
        data_out => i_mux3_out
    );

    data_out <= i_mux3_out;


end architecture;

