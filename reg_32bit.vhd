library ieee;
use ieee.std_logic_1164.all;

entity reg_32bit is
	port(
		reset_bar, load_bar : in std_logic;
		clk : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0)
		);
end reg_32bit;

architecture reg_32bit_struc of reg_32bit is

signal i_data : std_logic_vector(31 downto 0);
signal i_data_bar : std_logic_vector(31 downto 0);
signal i_data_in : std_logic_vector(31 downto 0);
signal i_load : std_logic;

signal dL_in : std_logic_vector(31 downto 0);
signal dL_load : std_logic_vector(31 downto 0);


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
	l31 : d_Latch port map (
		i_d => dL_in(31),
		i_enable => dL_load(31),
		o_q => i_data_in(31),
		o_qBar => open
	);

	-- DFF to hold bit 31 of data
	bit31 : dflipflop port map (
		i_d => i_data_in(31),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(31),
		o_qbar => i_data_bar(31)
	);

    -- D Latch to preserve bus input
	l30 : d_Latch port map (
		i_d => dL_in(30),
		i_enable => dL_load(30),
		o_q => i_data_in(30),
		o_qBar => open
	);

	-- DFF to hold bit 30 of data
	bit30 : dflipflop port map (
		i_d => i_data_in(30),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(30),
		o_qbar => i_data_bar(30)
	);

    -- D Latch to preserve bus input
	l29 : d_Latch port map (
		i_d => dL_in(29),
		i_enable => dL_load(29),
		o_q => i_data_in(29),
		o_qBar => open
	);

	-- DFF to hold bit 29 of data
	bit29 : dflipflop port map (
		i_d => i_data_in(29),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(29),
		o_qbar => i_data_bar(29)
	);

    -- D Latch to preserve bus input
	l28 : d_Latch port map (
		i_d => dL_in(28),
		i_enable => dL_load(28),
		o_q => i_data_in(28),
		o_qBar => open
	);

	-- DFF to hold bit 28 of data
	bit28 : dflipflop port map (
		i_d => i_data_in(28),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(28),
		o_qbar => i_data_bar(28)
	);

    -- D Latch to preserve bus input
	l27 : d_Latch port map (
		i_d => dL_in(27),
		i_enable => dL_load(27),
		o_q => i_data_in(27),
		o_qBar => open
	);

	-- DFF to hold bit 27 of data
	bit27 : dflipflop port map (
		i_d => i_data_in(27),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(27),
		o_qbar => i_data_bar(27)
	);

    -- D Latch to preserve bus input
	l26 : d_Latch port map (
		i_d => dL_in(26),
		i_enable => dL_load(26),
		o_q => i_data_in(26),
		o_qBar => open
	);

	-- DFF to hold bit 26 of data
	bit26 : dflipflop port map (
		i_d => i_data_in(26),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(26),
		o_qbar => i_data_bar(26)
	);

    -- D Latch to preserve bus input
	l25 : d_Latch port map (
		i_d => dL_in(25),
		i_enable => dL_load(25),
		o_q => i_data_in(25),
		o_qBar => open
	);

	-- DFF to hold bit 25 of data
	bit25 : dflipflop port map (
		i_d => i_data_in(25),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(25),
		o_qbar => i_data_bar(25)
	);

    -- D Latch to preserve bus input
	l24 : d_Latch port map (
		i_d => dL_in(24),
		i_enable => dL_load(24),
		o_q => i_data_in(24),
		o_qBar => open
	);

	-- DFF to hold bit 24 of data
	bit24 : dflipflop port map (
		i_d => i_data_in(24),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(24),
		o_qbar => i_data_bar(24)
	);

-- D Latch to preserve bus input
	l23 : d_Latch port map (
		i_d => dL_in(23),
		i_enable => dL_load(23),
		o_q => i_data_in(23),
		o_qBar => open
	);

	-- DFF to hold bit 23 of data
	bit23 : dflipflop port map (
		i_d => i_data_in(23),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(23),
		o_qbar => i_data_bar(23)
	);

    -- D Latch to preserve bus input
	l22 : d_Latch port map (
		i_d => dL_in(22),
		i_enable => dL_load(22),
		o_q => i_data_in(22),
		o_qBar => open
	);

	-- DFF to hold bit 22 of data
	bit22 : dflipflop port map (
		i_d => i_data_in(22),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(22),
		o_qbar => i_data_bar(22)
	);

    -- D Latch to preserve bus input
	l21 : d_Latch port map (
		i_d => dL_in(21),
		i_enable => dL_load(21),
		o_q => i_data_in(21),
		o_qBar => open
	);

	-- DFF to hold bit 21 of data
	bit21 : dflipflop port map (
		i_d => i_data_in(21),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(21),
		o_qbar => i_data_bar(21)
	);

    -- D Latch to preserve bus input
	l20 : d_Latch port map (
		i_d => dL_in(20),
		i_enable => dL_load(20),
		o_q => i_data_in(20),
		o_qBar => open
	);

	-- DFF to hold bit 20 of data
	bit20 : dflipflop port map (
		i_d => i_data_in(20),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(20),
		o_qbar => i_data_bar(20)
	);

    -- D Latch to preserve bus input
	l19 : d_Latch port map (
		i_d => dL_in(19),
		i_enable => dL_load(19),
		o_q => i_data_in(19),
		o_qBar => open
	);

	-- DFF to hold bit 19 of data
	bit19 : dflipflop port map (
		i_d => i_data_in(19),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(19),
		o_qbar => i_data_bar(19)
	);

    -- D Latch to preserve bus input
	l18 : d_Latch port map (
		i_d => dL_in(18),
		i_enable => dL_load(18),
		o_q => i_data_in(18),
		o_qBar => open
	);

	-- DFF to hold bit 18 of data
	bit18 : dflipflop port map (
		i_d => i_data_in(18),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(18),
		o_qbar => i_data_bar(18)
	);

    -- D Latch to preserve bus input
	l17 : d_Latch port map (
		i_d => dL_in(17),
		i_enable => dL_load(17),
		o_q => i_data_in(17),
		o_qBar => open
	);

	-- DFF to hold bit 17 of data
	bit17 : dflipflop port map (
		i_d => i_data_in(17),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(17),
		o_qbar => i_data_bar(17)
	);

    -- D Latch to preserve bus input
	l16 : d_Latch port map (
		i_d => dL_in(16),
		i_enable => dL_load(16),
		o_q => i_data_in(16),
		o_qBar => open
	);

	-- DFF to hold bit 16 of data
	bit16 : dflipflop port map (
		i_d => i_data_in(16),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(16),
		o_qbar => i_data_bar(16)
	);


	-- D Latch to preserve bus input
	l15 : d_Latch port map (
		i_d => dL_in(15),
		i_enable => dL_load(15),
		o_q => i_data_in(15),
		o_qBar => open
	);

	-- DFF to hold bit 15 of data
	bit15 : dflipflop port map (
		i_d => i_data_in(15),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(15),
		o_qbar => i_data_bar(15)
	);

    -- D Latch to preserve bus input
	l14 : d_Latch port map (
		i_d => dL_in(14),
		i_enable => dL_load(14),
		o_q => i_data_in(14),
		o_qBar => open
	);

	-- DFF to hold bit 14 of data
	bit14 : dflipflop port map (
		i_d => i_data_in(14),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(14),
		o_qbar => i_data_bar(14)
	);

    -- D Latch to preserve bus input
	l13 : d_Latch port map (
		i_d => dL_in(13),
		i_enable => dL_load(13),
		o_q => i_data_in(13),
		o_qBar => open
	);

	-- DFF to hold bit 13 of data
	bit13 : dflipflop port map (
		i_d => i_data_in(13),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(13),
		o_qbar => i_data_bar(13)
	);

    -- D Latch to preserve bus input
	l12 : d_Latch port map (
		i_d => dL_in(12),
		i_enable => dL_load(12),
		o_q => i_data_in(12),
		o_qBar => open
	);

	-- DFF to hold bit 12 of data
	bit12 : dflipflop port map (
		i_d => i_data_in(12),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(12),
		o_qbar => i_data_bar(12)
	);

    -- D Latch to preserve bus input
	l11 : d_Latch port map (
		i_d => dL_in(11),
		i_enable => dL_load(11),
		o_q => i_data_in(11),
		o_qBar => open
	);

	-- DFF to hold bit 11 of data
	bit11 : dflipflop port map (
		i_d => i_data_in(11),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(11),
		o_qbar => i_data_bar(11)
	);

    -- D Latch to preserve bus input
	l10 : d_Latch port map (
		i_d => dL_in(10),
		i_enable => dL_load(10),
		o_q => i_data_in(10),
		o_qBar => open
	);

	-- DFF to hold bit 10 of data
	bit10 : dflipflop port map (
		i_d => i_data_in(10),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(10),
		o_qbar => i_data_bar(10)
	);

    -- D Latch to preserve bus input
	l9 : d_Latch port map (
		i_d => dL_in(9),
		i_enable => dL_load(9),
		o_q => i_data_in(9),
		o_qBar => open
	);

	-- DFF to hold bit 9 of data
	bit9 : dflipflop port map (
		i_d => i_data_in(9),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(9),
		o_qbar => i_data_bar(9)
	);

    -- D Latch to preserve bus input
	l8 : d_Latch port map (
		i_d => dL_in(8),
		i_enable => dL_load(8),
		o_q => i_data_in(8),
		o_qBar => open
	);

	-- DFF to hold bit 8 of data
	bit8 : dflipflop port map (
		i_d => i_data_in(8),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(8),
		o_qbar => i_data_bar(8)
	);

	-- D Latch to preserve bus input
	l7 : d_Latch port map (
		i_d => dL_in(7),
		i_enable => dL_load(7),
		o_q => i_data_in(7),
		o_qBar => open
	);

	-- DFF to hold bit 7 of data
	bit7 : dflipflop port map (
		i_d => i_data_in(7),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(7),
		o_qbar => i_data_bar(7)
	);

	-- D Latch to preserve bus input
	l6 : d_Latch port map (
		i_d => dL_in(6),
		i_enable => dL_load(6),
		o_q => i_data_in(6)
	);

	-- DFF to hold bit 6 of data
	bit6 : dflipflop port map (
		i_d => i_data_in(6),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(6),
		o_qbar => i_data_bar(6)
	);

	-- D Latch to preserve bus input
	l5 : d_Latch port map (
		i_d => dL_in(5),
		i_enable => dL_load(5),
		o_q => i_data_in(5)
	);

	-- DFF to hold bit 5 of data
	bit5 : dflipflop port map (
		i_d => i_data_in(5),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_data(5),
		o_qbar => i_data_bar(5)
	);

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

    dL_in(31) <= reset_bar and data_in(31);
	dL_in(30) <= reset_bar and data_in(30);
	dL_in(29) <= reset_bar and data_in(29);
	dL_in(28) <= reset_bar and data_in(28);
	dL_in(27) <= reset_bar and data_in(27);
	dL_in(26) <= reset_bar and data_in(26);
	dL_in(25) <= reset_bar and data_in(25);
	dL_in(24) <= reset_bar and data_in(24);
	dL_in(23) <= reset_bar and data_in(23);
	dL_in(22) <= reset_bar and data_in(22);
	dL_in(21) <= reset_bar and data_in(21);
	dL_in(20) <= reset_bar and data_in(20);
	dL_in(19) <= reset_bar and data_in(19);
	dL_in(18) <= reset_bar and data_in(18);
	dL_in(17) <= reset_bar and data_in(17);
	dL_in(16) <= reset_bar and data_in(16);
	dL_in(15) <= reset_bar and data_in(15);
	dL_in(14) <= reset_bar and data_in(14);
	dL_in(13) <= reset_bar and data_in(13);
	dL_in(12) <= reset_bar and data_in(12);
	dL_in(11) <= reset_bar and data_in(11);
	dL_in(10) <= reset_bar and data_in(10);
	dL_in(9) <= reset_bar and data_in(9);
	dL_in(8) <= reset_bar and data_in(8);
	dL_in(7) <= reset_bar and data_in(7);
	dL_in(6) <= reset_bar and data_in(6);
	dL_in(5) <= reset_bar and data_in(5);
	dL_in(4) <= reset_bar and data_in(4);
	dL_in(3) <= reset_bar and data_in(3);
	dL_in(2) <= reset_bar and data_in(2);
	dL_in(1) <= reset_bar and data_in(1);
	dL_in(0) <= reset_bar and data_in(0);

    dL_load(31) <= (not reset_bar) or i_load;
	dL_load(30) <= (not reset_bar) or i_load;
	dL_load(29) <= (not reset_bar) or i_load;
	dL_load(28) <= (not reset_bar) or i_load;
	dL_load(27) <= (not reset_bar) or i_load;
	dL_load(26) <= (not reset_bar) or i_load;
	dL_load(25) <= (not reset_bar) or i_load;
	dL_load(24) <= (not reset_bar) or i_load;
	dL_load(23) <= (not reset_bar) or i_load;
	dL_load(22) <= (not reset_bar) or i_load;
	dL_load(21) <= (not reset_bar) or i_load;
	dL_load(20) <= (not reset_bar) or i_load;
	dL_load(19) <= (not reset_bar) or i_load;
	dL_load(18) <= (not reset_bar) or i_load;
	dL_load(17) <= (not reset_bar) or i_load;
	dL_load(16) <= (not reset_bar) or i_load;
	dL_load(15) <= (not reset_bar) or i_load;
	dL_load(14) <= (not reset_bar) or i_load;
	dL_load(13) <= (not reset_bar) or i_load;
	dL_load(12) <= (not reset_bar) or i_load;
	dL_load(11) <= (not reset_bar) or i_load;
	dL_load(10) <= (not reset_bar) or i_load;
	dL_load(9) <= (not reset_bar) or i_load;
	dL_load(8) <= (not reset_bar) or i_load;
	dL_load(7) <= (not reset_bar) or i_load;
	dL_load(6) <= (not reset_bar) or i_load;
	dL_load(5) <= (not reset_bar) or i_load;
	dL_load(4) <= (not reset_bar) or i_load;
	dL_load(3) <= (not reset_bar) or i_load;
	dL_load(2) <= (not reset_bar) or i_load;
	dL_load(1) <= (not reset_bar) or i_load;
	dL_load(0) <= (not reset_bar) or i_load;

	-- Output Driver:
	data_out <= i_data;

end reg_32bit_struc;