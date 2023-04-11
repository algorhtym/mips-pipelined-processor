library ieee;
use ieee.std_logic_1164.all;

entity adder_8bit is
	port( add_sub_cont : in std_logic;
			x : in std_logic_vector(7 downto 0);
			y : in std_logic_vector(7 downto 0);
			s : out std_logic_vector(7 downto 0);
			z : out std_logic;
			c_n : out std_logic;
			o_f : out std_logic);
end adder_8bit;
			
architecture struc of adder_8bit is 

	signal y7,y6,y5,y4,y3,y2,y1,y0 : std_logic;
	signal c8,c7,c6,c5,c4,c3,c2,c1,c0 : std_logic;
	signal i_z : std_logic;
	signal i_s : std_logic_vector(7 downto 0);

	component fa_1bit 
		PORT( Ci : IN STD_LOGIC;
				Xi, Yi : IN STD_LOGIC;
				Si, Ci_1 : OUT STD_LOGIC);
	end component;

	component xor_2 
		port( a, b : in std_logic;
				y : out std_logic);
	end component;


begin 

	as0 : xor_2 port map (y(0),add_sub_cont,y0);
	as1 : xor_2 port map (y(1),add_sub_cont,y1);
	as2 : xor_2 port map (y(2),add_sub_cont,y2);
	as3 : xor_2 port map (y(3),add_sub_cont,y3);
	as4 : xor_2 port map (y(4),add_sub_cont,y4);
	as5 : xor_2 port map (y(5),add_sub_cont,y5);
	as6 : xor_2 port map (y(6),add_sub_cont,y6);
	as7 : xor_2 port map (y(7),add_sub_cont,y7);

	u0 : fa_1bit port map (add_sub_cont, x(0), y0, i_s(0), c1);
	u1 : fa_1bit port map (c1, x(1), y1, i_s(1), c2);
	u2 : fa_1bit port map (c2, x(2), y2, i_s(2), c3);
	u3 : fa_1bit port map (c3, x(3), y3, i_s(3), c4);
	u4 : fa_1bit port map (c4, x(4), y4, i_s(4), c5);
	u5 : fa_1bit port map (c5, x(5), y5, i_s(5), c6);
	u6 : fa_1bit port map (c6, x(6), y6, i_s(6), c7);
	u7 : fa_1bit port map (c7, x(7), y7, i_s(7), c8);

	-- Generate zero flag
	i_z <= ((i_s(7) or i_s(6)) or (i_s(5) or i_s(4))) nor ((i_s(3) or i_s(2)) or (i_s(1) or i_s(0)));

	s <= i_s;
	o_f <= c8 xor c7;
	c_n <= c8;
	z <= i_z;

end struc;