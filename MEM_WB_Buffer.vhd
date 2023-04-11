library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
-- MEM/WB Buffer (MEM_WB_Buffer)
--- regs: 
--- 1) MEM_WB_EX (null) &  MEM_WB_MEM (null) & MEM_WB_WB (8bit reg)
--- 2) MEM_WB_ReadData (8bit)
--- 3) MEM_WB_ALUResult (8bit)
--- 4) MEM_WB_reg_Rd (5bit)
--- 5) i_InstructionOut5

entity MEM_WB_Buffer is
    port (
        clk   : in std_logic;
        reset_bar : in std_logic;
        MEM_WB_cont_in, MEM_WB_ReadData_in, MEM_WB_ALUResult_in : in std_Logic_vector(7 downto 0);
        MEM_WB_reg_Rd_in : in std_Logic_vector(4 downto 0);
        MEM_WB_instructionOut5_in : in std_logic_vector(31 downto 0);
        MEM_WB_cont_out, MEM_WB_ReadData_out, MEM_WB_ALUResult_out : out std_Logic_vector(7 downto 0);
        MEM_WB_reg_Rd_out : out std_Logic_vector(4 downto 0);
        MEM_WB_instructionOut5_out : out std_logic_vector(31 downto 0)        
    );
end entity MEM_WB_Buffer;

architecture rtl of MEM_WB_Buffer is

    signal i_MEM_WB_cont_out, i_MEM_WB_ReadData_out, i_MEM_WB_ALUResult_out : std_Logic_vector(7 downto 0);
    signal i_MEM_WB_reg_Rd_out : std_Logic_vector(4 downto 0);
    signal i_MEM_WB_instructionOut5_out : std_logic_vector(31 downto 0);


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
        data_in => MEM_WB_cont_in,
        data_out => i_MEM_WB_cont_out
    );
    
    EX_MEM_ALUResult_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => MEM_WB_ReadData_in,
        data_out => i_MEM_WB_ReadData_out
    );

    EX_MEM_WriteData_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => MEM_WB_ALUResult_in,
        data_out => i_MEM_WB_ALUResult_out
    );

    EX_MEM_reg_Rd_reg : reg_5bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => MEM_WB_reg_Rd_in,
        data_out => i_MEM_WB_reg_Rd_out
    );

    EX_MEM_instructionOut4_out_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => MEM_WB_instructionOut5_in,
        data_out => i_MEM_WB_instructionOut5_out
    );

    -- output driver

    MEM_WB_cont_out <= i_MEM_WB_cont_out;
    MEM_WB_ReadData_out <= i_MEM_WB_ReadData_out;
    MEM_WB_ALUResult_out <= i_MEM_WB_ALUResult_out;
    MEM_WB_reg_Rd_out <= i_MEM_WB_reg_Rd_out;
    MEM_WB_instructionOut5_out <= i_MEM_WB_instructionOut5_out;
    

end architecture;