library ieee;
use ieee.std_logic_1164.all;

entity sign_truncate_16to8 is
    port (
        data_in : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(7 downto 0)
        
    );
end entity;

architecture struc of sign_truncate_16to8 is
    -- signals
    signal i_data_out : std_logic_vector(7 downto 0);
    signal i_sign : std_logic;
    


begin
    -- capturing the sign bit
    i_sign <= data_in(15);

    i_data_out(7) <= i_sign;
    i_data_out(6) <= data_in(6);
    i_data_out(5) <= data_in(5);
    i_data_out(4) <= data_in(4);
    i_data_out(3) <= data_in(3);
    i_data_out(2) <= data_in(2);
    i_data_out(1) <= data_in(1);
    i_data_out(0) <= data_in(0);

    -- detect overflow
    

    data_out <= i_data_out;
    


end architecture;