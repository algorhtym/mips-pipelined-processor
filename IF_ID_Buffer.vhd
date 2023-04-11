library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
    -- IF/ID Buffer (IF_ID_Buffer)
    --- regs:
    --- 1) PC+4 (8 bits)
    --- 2) Instruction (32 bits) (i_InstructionOut2)
    --- inputs signals:
    --- 1) IF_Flush signal (zeros the instruction field)
    --- 2) IF_ID_Write signal (allows write into the buffer)

entity IF_ID_Buffer is
    port (
        clk   : in std_logic;
        reset_bar : in std_logic;
        pc_plus_4_in : in std_logic_vector(7 downto 0);
        instructionOut2_in : in std_logic_vector(31 downto 0);
        IF_Flush : in std_logic;
        IF_ID_Write : in std_logic;
        pc_plus_4_out : out std_logic_vector(7 downto 0);
        instructionOut2_out : out std_logic_vector(31 downto 0) 
    );
end entity IF_ID_Buffer;

architecture rtl of IF_ID_Buffer is

    -- signal declarations
    signal i_IF_Flush_bar, i_IF_ID_Write_bar : std_logic; 
    signal i_pc_plus_4_out : std_logic_vector(7 downto 0);
    signal i_instructionOut2_out : std_logic_vector(31 downto 0);
    signal i_instr_reset_bar : std_logic;


    -- component declarations
    component reg_8bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
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

    -- component instantiations and concurrent signal assignments
    

    pc_plus4_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_IF_ID_Write_bar,
        clk => clk,
        data_in => pc_plus_4_in,
        data_out => i_pc_plus_4_out
    );

    i_InstructionOut2_reg : reg_32bit port map (
        reset_bar => i_instr_reset_bar, load_bar => i_IF_ID_Write_bar,
        clk => clk,
        data_in => instructionOut2_in,
        data_out => i_instructionOut2_out
    );


    i_IF_Flush_bar <= not IF_Flush;
    i_IF_ID_Write_bar <= not IF_ID_Write;

    -- reset in case of reset signal or flush signal
    i_instr_reset_bar <= reset_bar and i_IF_Flush_bar;


    -- output driver
    pc_plus_4_out <= i_pc_plus_4_out;
    instructionOut2_out <= i_instructionOut2_out;


    

end architecture;