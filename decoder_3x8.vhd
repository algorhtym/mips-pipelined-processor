library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_3x8 is
    port (
        sel : in std_logic_vector(2 downto 0);
        decode_out : out std_logic_vector(7 downto 0)
    );
end entity decoder_3x8;

architecture struc of decoder_3x8 is

    signal i_sel : std_logic_vector(2 downto 0);
    signal i_and_out : std_logic_vector(7 downto 0);

begin

    i_and_out(7) <= (i_sel(2) and i_sel(1)) and i_sel(0);
    i_and_out(6) <= (i_sel(2) and i_sel(1)) and not i_sel(0);
    i_and_out(5) <= (i_sel(2) and not i_sel(1)) and i_sel(0);
    i_and_out(4) <= (i_sel(2) and not i_sel(1)) and not i_sel(0);
    i_and_out(3) <= (not i_sel(2) and i_sel(1)) and i_sel(0);
    i_and_out(2) <= (not i_sel(2) and i_sel(1)) and not i_sel(0);
    i_and_out(1) <= (not i_sel(2) and not i_sel(1)) and i_sel(0);
    i_and_out(0) <= (not i_sel(2) and not i_sel(1)) and not i_sel(0);

    i_sel <= sel;

    decode_out <= i_and_out;

    

end architecture;