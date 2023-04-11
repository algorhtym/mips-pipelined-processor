library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_file_8x8 is
    port (
        clk   : in std_logic;
        reset_bar : in std_logic;
        read_reg1, read_reg2 : in std_logic_vector(4 downto 0);
        write_reg : in std_logic_vector(4 downto 0);
        write_data : in std_logic_vector(7 downto 0);
        wr : in  std_logic;
        read_data1 : out std_logic_vector(7 downto 0);
        read_data2 : out std_logic_vector(7 downto 0)
    );
end entity;

architecture struc of register_file_8x8 is

    -- signal declarations


    -- signals for the read ports 1 and 2
    signal i_read_reg1, i_read_reg2 : std_logic_vector(4 downto 0);
    signal i_reg_out0, i_reg_out1,i_reg_out2,i_reg_out3,i_reg_out4,i_reg_out5,i_reg_out6,i_reg_out7 : std_logic_vector(7 downto 0); 
    signal i_read_data1, i_read_data2 : std_logic_vector(7 downto 0);      


    -- signals for the write port
    signal i_write_reg : std_logic_vector(4 downto 0);
    signal i_load_bar : std_logic_vector(7 downto 0);
    signal i_dec_out : std_logic_vector(7 downto 0);

    -- component declarations

    -- 8 bit register (PC Register)
    component reg_8bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
            );
    end component;


    -- 8 bit 8x1 MUX for the Read ports
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

    -- 3x8 decoder for the write port
    component decoder_3x8 is
        port (
            sel : in std_logic_vector(2 downto 0);
            decode_out : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- component connections

    -- registers

    reg0 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(0),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out0
    );

    reg1 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(1),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out1
    );

    reg2 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(2),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out2
    );

    reg3 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(3),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out3
    );

    reg4 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(4),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out4
    );

    reg5 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(5),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out5
    );

    reg6 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(6),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out6
    );

    reg7 : reg_8bit port map (
        reset_bar => reset_bar, load_bar => i_load_bar(7),
        clk => clk,
        data_in => write_data,
        data_out => i_reg_out7
    );


    -- write port decoder
    decoder : decoder_3x8 port map (
        sel => i_write_reg(2) & i_write_reg(1) & i_write_reg(0),
        decode_out => i_dec_out
    );

    -- read data 1 mux
    read_data1_mux : mux_8bit_8x1 port map (
        sel => i_read_reg1(2) & i_read_reg1(1) & i_read_reg1(0),
        data_in0 => i_reg_out0,
        data_in1 => i_reg_out1,
        data_in2 => i_reg_out2,
        data_in3 => i_reg_out3,
        data_in4 => i_reg_out4,
        data_in5 => i_reg_out5,
        data_in6 => i_reg_out6,
        data_in7 => i_reg_out7,
        data_out => i_read_data1
    );

    -- read data 1 mux
    read_data2_mux : mux_8bit_8x1 port map (
        sel => i_read_reg2(2) & i_read_reg2(1) & i_read_reg2(0),
        data_in0 => i_reg_out0,
        data_in1 => i_reg_out1,
        data_in2 => i_reg_out2,
        data_in3 => i_reg_out3,
        data_in4 => i_reg_out4,
        data_in5 => i_reg_out5,
        data_in6 => i_reg_out6,
        data_in7 => i_reg_out7,
        data_out => i_read_data2
    );




    -- concurrent signal connections

    i_read_reg1 <= read_reg1;
    i_read_reg2 <= read_reg2;
    i_write_reg <= write_reg;


    i_load_bar(7) <= not (wr and i_dec_out(7));
    i_load_bar(6) <= not (wr and i_dec_out(6));
    i_load_bar(5) <= not (wr and i_dec_out(5));
    i_load_bar(4) <= not (wr and i_dec_out(4));
    i_load_bar(3) <= not (wr and i_dec_out(3));
    i_load_bar(2) <= not (wr and i_dec_out(2));
    i_load_bar(1) <= not (wr and i_dec_out(1));
    i_load_bar(0) <= not (wr and i_dec_out(0));
    

    -- output driver
	 read_data1 <= i_read_data1;
	 read_data2 <= i_read_data2;
    

end architecture;