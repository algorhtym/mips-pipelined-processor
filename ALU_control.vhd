LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ALU_control is
    port (
        funct : in std_logic_vector(5 downto 0);
        ALU_op : in std_logic_vector(1 downto 0);
        ALU_cont : out std_logic_vector(3 downto 0)
    );
end entity ALU_control;

architecture rtl of ALU_control is

    signal i_alu_op0, i_alu_op1 : std_logic;
    signal f : std_logic_vector(3 downto 0); -- expand when funct field increases
    signal op2, op1, op0 : std_logic;
    signal i_ALU_cont : std_logic_vector(3 downto 0);

begin

    i_alu_op0 <= ALU_op(0);
    i_alu_op1 <= ALU_op(1);
    f(3) <= funct(3);
    f(2) <= funct(2);
    f(1) <= funct(1);
    f(0) <= funct(0);

    i_ALU_cont(3) <= '0'; -- for now there is no use for the A_inv control
    i_ALU_cont(2) <= i_alu_op0 or (i_alu_op1 and f(1));
    i_ALU_cont(1) <= (not i_alu_op1) or (not f(2));
    i_ALU_cont(0) <= (i_alu_op1 and (f(3) or f(0)));


    -- output driver

    ALU_cont <= i_ALU_cont;

    

end architecture;