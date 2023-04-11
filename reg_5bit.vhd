library ieee;
use ieee.std_logic_1164.all;

entity reg_5bit is
	port(
		reset_bar, load_bar : in std_logic;
		clk : in std_logic;
		data_in : in std_logic_vector(4 downto 0);
		data_out : out std_logic_vector(4 downto 0)
		);
end reg_5bit;

architecture reg_5bit_struc of reg_5bit is

signal i_data : std_logic_vector(4 downto 0);
signal i_data_bar : std_logic_vector(4 downto 0);
signal i_data_in : std_logic_vector(4 downto 0);
signal i_load : std_logic;

signal dL_in : std_logic_vector(4 downto 0);
signal dL_load : std_logic_vector(4 downto 0);


component dflipflop is
	port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
			o_q, o_qbar : inout STD_LOGIC);
end component;

component d_Latch IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
end component;

begin
	

	-- D Latch to preserve bus input
	l4 : d_Latch port map (
		i_d => dL_in(4),
		i_enable => dL_load(4),
		o_q => i_data_in(4)
	);

	-- DFF to hold bit 4 of data
	bit4 : dflipflop port map (
		i_d => i_data_in(4),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(4),
		o_qbar => i_data_bar(4)
	);

	-- D Latch to preserve bus input
	l3 : d_Latch port map (
		i_d => dL_in(3),
		i_enable => dL_load(3),
		o_q => i_data_in(3)
	);

	-- DFF to hold bit 3 of data
	bit3 : dflipflop port map (
		i_d => i_data_in(3),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(3),
		o_qbar => i_data_bar(3)
	);

	-- D Latch to preserve bus input
	l2 : d_Latch port map (
		i_d => dL_in(2),
		i_enable => dL_load(2),
		o_q => i_data_in(2)
	);

	-- DFF to hold bit 2 of data
	bit2 : dflipflop port map (
		i_d => i_data_in(2),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(2),
		o_qbar => i_data_bar(2)
	);
	
	-- D Latch to preserve bus input
	l1 : d_Latch port map (
		i_d => dL_in(1),
		i_enable => dL_load(1),
		o_q => i_data_in(1)
	);

	-- DFF to hold bit 1 of data
	bit1 : dflipflop port map (
		i_d => i_data_in(1),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(1),
		o_qbar => i_data_bar(1)
	);

	-- D Latch to preserve bus input
	l0 : d_Latch port map (
		i_d => dL_in(0),
		i_enable => dL_load(0),
		o_q => i_data_in(0)
	);

	-- DFF to hold bit 0 of data
	bit0 : dflipflop port map (
		i_d => i_data_in(0),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(0),
		o_qbar => i_data_bar(0)
	);
	
	-- Concurrent signal assignments 
	i_load <= not load_bar;
	dL_in(4) <= reset_bar and data_in(4);
	dL_in(3) <= reset_bar and data_in(3);
	dL_in(2) <= reset_bar and data_in(2);
	dL_in(1) <= reset_bar and data_in(1);
	dL_in(0) <= reset_bar and data_in(0);

	dL_load(4) <= (not reset_bar) or i_load;
	dL_load(3) <= (not reset_bar) or i_load;
	dL_load(2) <= (not reset_bar) or i_load;
	dL_load(1) <= (not reset_bar) or i_load;
	dL_load(0) <= (not reset_bar) or i_load;

	-- Output Driver:
	data_out <= i_data;

end reg_5bit_struc;