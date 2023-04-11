library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instructionOutRegister is
    port (
        reset_bar : in std_logic;
        clk : in std_logic;
        sel : in std_logic_vector(2 downto 0);
        data_in0 : in std_logic_vector(31 downto 0);
        data_in1 : in std_logic_vector(31 downto 0);
        data_in2 : in std_logic_vector(31 downto 0);
        data_in3 : in std_logic_vector(31 downto 0);
        data_in4 : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture struc of instructionOutRegister is
    -- signal dec
    signal instructionOut1, instructionOut2, instructionOut3, instructionOut4, instructionOut5 : std_logic_vector(31 downto 0);
    signal i_data_out : std_logic_vector(31 downto 0);
    signal i_dec_out : std_logic_vector(7 downto 0);
    signal i_mux1out, i_mux2out, i_mux3out, i_mux4out : std_logic_vector(7 downto 0);
    
    -- component dec

    component reg_32bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(31 downto 0);
            data_out : out std_logic_vector(31 downto 0)
            );
    end component;


    component mux_8bit_8x1 is
        port (
            sel : in std_logic_vector(2 downto 0);
            data_in0 : in std_logic_vector(7 downto 0);
            data_in1 : in std_logic_vector(7 downto 0);
            data_in2 : in std_logic_vector(7 downto 0);
            data_in3 : in std_logic_vector(7 downto 0);
            data_in4 : in std_logic_vector(7 downto 0);
            data_in5 : in std_logic_vector(7 downto 0);
            data_in6 : in std_logic_vector(7 downto 0);
            data_in7 : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;


begin

    -- component instantiations


    instr1_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => data_in0,
        data_out => instructionOut1
    );

    instr2_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => data_in1,
        data_out => instructionOut2
    );

    instr3_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => data_in2,
        data_out => instructionOut3
    );

    instr4_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => data_in3,
        data_out => instructionOut4
    );

    instr5_reg : reg_32bit port map (
        reset_bar => reset_bar, load_bar => '0',
        clk => clk,
        data_in => data_in4,
        data_out => instructionOut5
    );


    mux1 : mux_8bit_8x1 port map (
        sel => sel,
        data_in0 => instructionOut1(31 downto 24),
        data_in1 => instructionOut2(31 downto 24),
        data_in2 => instructionOut3(31 downto 24),
        data_in3 => instructionOut4(31 downto 24),
        data_in4 => instructionOut5(31 downto 24),
        data_in5 => "00000000",
        data_in6 => "00000000",
        data_in7 => "00000000",
        data_out => i_mux1out
    );

    mux2 : mux_8bit_8x1 port map (
        sel => sel,
        data_in0 => instructionOut1(23 downto 16),
        data_in1 => instructionOut2(23 downto 16),
        data_in2 => instructionOut3(23 downto 16),
        data_in3 => instructionOut4(23 downto 16),
        data_in4 => instructionOut5(23 downto 16),
        data_in5 => "00000000",
        data_in6 => "00000000",
        data_in7 => "00000000",
        data_out => i_mux2out
    );

    mux3 : mux_8bit_8x1 port map (
        sel => sel,
        data_in0 => instructionOut1(15 downto 8),
        data_in1 => instructionOut2(15 downto 8),
        data_in2 => instructionOut3(15 downto 8),
        data_in3 => instructionOut4(15 downto 8),
        data_in4 => instructionOut5(15 downto 8),
        data_in5 => "00000000",
        data_in6 => "00000000",
        data_in7 => "00000000",
        data_out => i_mux3out
    );

    
    mux4 : mux_8bit_8x1 port map (
        sel => sel,
        data_in0 => instructionOut1(7 downto 0),
        data_in1 => instructionOut2(7 downto 0),
        data_in2 => instructionOut3(7 downto 0),
        data_in3 => instructionOut4(7 downto 0),
        data_in4 => instructionOut5(7 downto 0),
        data_in5 => "00000000",
        data_in6 => "00000000",
        data_in7 => "00000000",
        data_out => i_mux4out
    );



    i_data_out <= i_mux1out & i_mux2out & i_mux3out & i_mux4out;

    -- output driver
    data_out <= i_data_out;

    

end architecture;