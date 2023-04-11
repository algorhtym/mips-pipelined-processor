library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_6 is
    port (
        and6_in : in std_logic_vector(5 downto 0);
        and6_out : out std_logic
    );
end entity and_6;

architecture struc of and_6 is
    signal i_and6_out : std_logic;

begin

    i_and6_out <= ( ( and6_in(5) and and6_in(4) ) and ( and6_in(3) and and6_in(2) ) ) and ( and6_in(1) and and6_in(0) );
    and6_out <= i_and6_out;

end architecture;