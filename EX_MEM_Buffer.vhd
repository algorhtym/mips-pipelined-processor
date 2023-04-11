library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
    -- EX/MEM Buffer (EX_MEM_Buffer)
    --- regs: 
    --- 1) EX_MEM_EX (null) &  EX_MEM_MEM & EX_MEM_WB (8bit reg)
    --- 2) EX_MEM_ALUResult (8bit)
    --- 3) EX_MEM_writeData ***(new signal)***
    --- 4) EX_MEM_reg_Rd (5bit)
    --- 5) i_InstructionOut4

entity EX_MEM_Buffer is
    port (
        clk   : in std_logic;
        reset_bar : in std_logic;
        EX_MEM_cont_in, EX_MEM_ALUResult_in, EX_MEM_WriteData_in : in std_Logic_vector(7 downto 0);
        EX_MEM_reg_Rd_in : in std_Logic_vector(4 downto 0);
        EX_MEM_instructionOut4_in : in std_logic_vector(31 downto 0);
        EX_MEM_cont_out, EX_MEM_ALUResult_out, EX_MEM_WriteData_out : out std_Logic_vector(7 downto 0);
        EX_MEM_reg_Rd_out : out std_Logic_vector(4 downto 0);
        EX_MEM_instructionOut4_out : out std_logic_vector(31 downto 0)        
    );
end entity EX_MEM_Buffer;

architecture rtl of EX_MEM_Buffer is

    signal i_EX_MEM_cont_out, i_EX_MEM_ALUResult_out, i_EX_MEM_WriteData_out : std_Logic_vector(7 downto 0);
    signal i_EX_MEM_reg_Rd_out : std_Logic_vector(4 downto 0);
    signal i_EX_MEM_instructionOut4_out : std_logic_vector(31 downto 0);


    -- component declarations
    component reg_8bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
            );
    end component;

    component reg_5bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(4 downto 0);
            data_out : out std_logic_vector(4 downto 0)
            );
    end component;

    component reg_32bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(31 downto 0);
            data_out : out std_logic_vector(31 downto 0)
            );
    end component;


begin

    EX_MEM_cont_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => EX_MEM_cont_in,
        data_out => i_EX_MEM_cont_out
    );
    
    EX_MEM_ALUResult_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => EX_MEM_ALUResult_in,
        data_out => i_EX_MEM_ALUResult_out
    );

    EX_MEM_WriteData_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => EX_MEM_WriteData_in,
        data_out => i_EX_MEM_WriteData_out
    );

    EX_MEM_reg_Rd_reg : reg_5bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => EX_MEM_reg_Rd_in,
        data_out => i_EX_MEM_reg_Rd_out
    );

    EX_MEM_instructionOut4_out_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => EX_MEM_instructionOut4_in,
        data_out => i_EX_MEM_instructionOut4_out
    );

    -- output driver

    EX_MEM_cont_out <= i_EX_MEM_cont_out;
    EX_MEM_ALUResult_out <= i_EX_MEM_ALUResult_out;
    EX_MEM_WriteData_out <= i_EX_MEM_WriteData_out;
    EX_MEM_reg_Rd_out <= i_EX_MEM_reg_Rd_out;
    EX_MEM_instructionOut4_out <= i_EX_MEM_instructionOut4_out;
    

end architecture;