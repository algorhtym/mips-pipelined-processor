library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---------------------------------------------
    -- ID/EX Buffer (ID_EX_Buffer)
    --- regs:
    --- 1) ID_EX_EX &  ID_EX_MEM & ID_EX_WB (8bit reg)
    --- 2) ID_EX_ReadData1 (8bit reg)
    --- 3) ID_EX_ReadData2 (8bit reg)
    --- 4) ID_EX_SignTrunc (8bit reg)
    --- 5) ID_EX_reg_Rs (5bit reg)
    --- 6) ID_EX_reg_Rt (5bit reg)
    --- 7) ID_EX_reg_Rd (5bit reg)
    --- 8) i_InstructionOut3 (32 bit)

entity ID_EX_Buffer is
    port (
        clk   : in std_logic;
        reset_bar : in std_logic;
        ID_EX_cont_in, ID_EX_ReadData1_in, ID_EX_ReadData2_in, ID_EX_SignTrunc_in : in std_logic_vector(7 downto 0);
        ID_EX_reg_Rs_in, ID_EX_reg_Rt_in, ID_EX_reg_Rd_in : in std_logic_vector(4 downto 0);
        ID_EX_instructionOut3_in : in std_logic_vector(31 downto 0);
        ID_EX_cont_out, ID_EX_ReadData1_out, ID_EX_ReadData2_out, ID_EX_SignTrunc_out : out std_logic_vector(7 downto 0);
        ID_EX_reg_Rs_out, ID_EX_reg_Rt_out, ID_EX_reg_Rd_out : out std_logic_vector(4 downto 0);
        ID_EX_instructionOut3_out : out std_logic_vector(31 downto 0)
    );
end entity ID_EX_Buffer;

architecture rtl of ID_EX_Buffer is

    -- signal declarations
    signal i_ID_EX_cont_out, i_ID_EX_ReadData1_out, i_ID_EX_ReadData2_out, i_ID_EX_SignTrunc_out : std_logic_vector(7 downto 0);
    signal i_ID_EX_reg_Rs_out, i_ID_EX_reg_Rt_out, i_ID_EX_reg_Rd_out : std_logic_vector(4 downto 0);
    signal i_ID_EX_instructionOut3_out : std_logic_vector(31 downto 0);


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

    -- component instantiations and concurrent signal assignments
    

    ID_EX_cont_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_cont_in,
        data_out => i_ID_EX_cont_out
    );

    ID_EX_ReadData1_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_ReadData1_in,
        data_out => i_ID_EX_ReadData1_out
    );

    ID_EX_ReadData2_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_ReadData2_in,
        data_out => i_ID_EX_ReadData2_out
    );

    ID_EX_SignTrunc_reg : reg_8bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_SignTrunc_in,
        data_out => i_ID_EX_SignTrunc_out
    );

    ID_EX_reg_Rs_reg : reg_5bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_reg_Rs_in,
        data_out => i_ID_EX_reg_Rs_out
    );


    ID_EX_reg_Rt_reg : reg_5bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_reg_Rt_in,
        data_out => i_ID_EX_reg_Rt_out
    );

    ID_EX_reg_Rd_reg : reg_5bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_reg_Rd_in,
        data_out => i_ID_EX_reg_Rd_out
    );

    i_InstructionOut3_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => ID_EX_instructionOut3_in,
        data_out => i_ID_EX_instructionOut3_out
    );

    -- output driver   
    ID_EX_cont_out <= i_ID_EX_cont_out; 
    ID_EX_ReadData1_out <= i_ID_EX_ReadData1_out;
    ID_EX_ReadData2_out <= i_ID_EX_ReadData2_out;
    ID_EX_SignTrunc_out <= i_ID_EX_SignTrunc_out;
    ID_EX_reg_Rs_out <= i_ID_EX_reg_Rs_out;
    ID_EX_reg_Rt_out <= i_ID_EX_reg_Rt_out;
    ID_EX_reg_Rd_out <= i_ID_EX_reg_Rd_out;
    ID_EX_instructionOut3_out <= i_ID_EX_instructionOut3_out;


end architecture;