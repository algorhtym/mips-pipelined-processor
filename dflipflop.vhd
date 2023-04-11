library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dflipflop is
	port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
			o_q, o_qbar : inout STD_LOGIC);
end dflipflop;


architecture dff_arc of dflipflop is

signal dff_d1, dff_d1b, dff_d2, dff_d2b: std_LOGIC;

begin

dff_d1 <= not(i_set and dff_d2b and dff_d1b);
dff_d1b <= not(dff_d1 and i_clk and i_rst);
dff_d2 <= not(dff_d1b and i_clk and dff_d2b);
dff_d2b <= not(dff_d2 and i_d and i_rst);

o_q <= not(i_set and dff_d1b and o_qbar);
o_qbar <= not(i_rst and dff_d2 and o_q);


end dff_arc;