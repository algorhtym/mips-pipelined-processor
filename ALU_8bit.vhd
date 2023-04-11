library ieee;
use ieee.std_logic_1164.all;

entity ALU_8bit is
	port(   
            op : in std_logic_vector(3 downto 0);
			x : in std_logic_vector(7 downto 0);
			y : in std_logic_vector(7 downto 0);
			s : out std_logic_vector(7 downto 0);
			z : out std_logic;
			o_f : out std_logic);
end ALU_8bit;
			
architecture struc of ALU_8bit is 
    signal a_inv, b_neg : std_logic;
    signal op_mux : std_logic_vector(1 downto 0);
    signal i_x, i_y : std_logic_vector(7 downto 0);
    signal i_cin : std_logic_vector(7 downto 0);
    signal i_c_o : std_logic;
    signal x_muxOut, y_muxOut : std_logic_vector(7 downto 0);
    signal andOut, orOut, addOut, less : std_logic_vector(7 downto 0);
    signal i_set : std_logic;
    signal i_of : std_logic;
	signal i_z : std_logic;
	signal i_s : std_logic_vector(7 downto 0);

    signal op_mux0, op_mux1, op_mux2, op_mux3 : std_logic_vector(7 downto 0);
    
    

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


	u0 : fa_1bit port map (i_cin(0), x_muxOut(0), y_muxOut(0), addOut(0), i_cin(1));
	u1 : fa_1bit port map (i_cin(1), x_muxOut(1), y_muxOut(1), addOut(1), i_cin(2));
	u2 : fa_1bit port map (i_cin(2), x_muxOut(2), y_muxOut(2), addOut(2), i_cin(3));
	u3 : fa_1bit port map (i_cin(3), x_muxOut(3), y_muxOut(3), addOut(3), i_cin(4));
	u4 : fa_1bit port map (i_cin(4), x_muxOut(4), y_muxOut(4), addOut(4), i_cin(5));
	u5 : fa_1bit port map (i_cin(5), x_muxOut(5), y_muxOut(5), addOut(5), i_cin(6));
	u6 : fa_1bit port map (i_cin(6), x_muxOut(6), y_muxOut(6), addOut(6), i_cin(7));
	u7 : fa_1bit port map (i_cin(7), x_muxOut(7), y_muxOut(7), addOut(7), i_c_o);

    -- concurrent signal connections

    a_inv <= op(3);
    b_neg <= op(2);
    

    i_x <= x;
    i_y <= y;

    x_muxOut(0) <= (i_x(0) and not a_inv) or (not i_x(0) and a_inv);
    x_muxOut(1) <= (i_x(1) and not a_inv) or (not i_x(1) and a_inv);
	x_muxOut(2) <= (i_x(2) and not a_inv) or (not i_x(2) and a_inv);
	x_muxOut(3) <= (i_x(3) and not a_inv) or (not i_x(3) and a_inv);
	x_muxOut(4) <= (i_x(4) and not a_inv) or (not i_x(4) and a_inv);
	x_muxOut(5) <= (i_x(5) and not a_inv) or (not i_x(5) and a_inv);
	x_muxOut(6) <= (i_x(6) and not a_inv) or (not i_x(6) and a_inv);
	x_muxOut(7) <= (i_x(7) and not a_inv) or (not i_x(7) and a_inv);

    y_muxOut(0) <= (i_y(0) and not b_neg) or (not i_y(0) and b_neg);
	y_muxOut(1) <= (i_y(1) and not b_neg) or (not i_y(1) and b_neg);
	y_muxOut(2) <= (i_y(2) and not b_neg) or (not i_y(2) and b_neg);
	y_muxOut(3) <= (i_y(3) and not b_neg) or (not i_y(3) and b_neg);
	y_muxOut(4) <= (i_y(4) and not b_neg) or (not i_y(4) and b_neg);
	y_muxOut(5) <= (i_y(5) and not b_neg) or (not i_y(5) and b_neg);
	y_muxOut(6) <= (i_y(6) and not b_neg) or (not i_y(6) and b_neg);
	y_muxOut(7) <= (i_y(7) and not b_neg) or (not i_y(7) and b_neg);

    andOut(0) <= x_muxOut(0) and y_muxOut(0);
	andOut(1) <= x_muxOut(1) and y_muxOut(1);
	andOut(2) <= x_muxOut(2) and y_muxOut(2);
	andOut(3) <= x_muxOut(3) and y_muxOut(3);
	andOut(4) <= x_muxOut(4) and y_muxOut(4);
	andOut(5) <= x_muxOut(5) and y_muxOut(5);
	andOut(6) <= x_muxOut(6) and y_muxOut(6);
	andOut(7) <= x_muxOut(7) and y_muxOut(7);


	orOut(0) <= x_muxOut(0) or y_muxOut(0);
	orOut(1) <= x_muxOut(1) or y_muxOut(1);
	orOut(2) <= x_muxOut(2) or y_muxOut(2);
	orOut(3) <= x_muxOut(3) or y_muxOut(3);
	orOut(4) <= x_muxOut(4) or y_muxOut(4);
	orOut(5) <= x_muxOut(5) or y_muxOut(5);
	orOut(6) <= x_muxOut(6) or y_muxOut(6);
	orOut(7) <= x_muxOut(7) or y_muxOut(7);

    i_cin(0) <= b_neg;

    i_set <= addOut(7);

    less <= "0000000" & i_set;

    i_of <= i_c_o xor i_cin(7);

	-- Generate zero flag
	i_z <= ((i_s(7) or i_s(6)) or (i_s(5) or i_s(4))) nor ((i_s(3) or i_s(2)) or (i_s(1) or i_s(0)));

    op_mux0(7) <= andOut(7) and (not op(1) and not op(0));
	op_mux0(6) <= andOut(6) and (not op(1) and not op(0));
	op_mux0(5) <= andOut(5) and (not op(1) and not op(0));
	op_mux0(4) <= andOut(4) and (not op(1) and not op(0));
	op_mux0(3) <= andOut(3) and (not op(1) and not op(0));
	op_mux0(2) <= andOut(2) and (not op(1) and not op(0));
	op_mux0(1) <= andOut(1) and (not op(1) and not op(0));
	op_mux0(0) <= andOut(0) and (not op(1) and not op(0));


	op_mux1(7) <= orOut(7) and (not op(1) and op(0));
	op_mux1(6) <= orOut(6) and (not op(1) and op(0));
	op_mux1(5) <= orOut(5) and (not op(1) and op(0));
	op_mux1(4) <= orOut(4) and (not op(1) and op(0));
	op_mux1(3) <= orOut(3) and (not op(1) and op(0));
	op_mux1(2) <= orOut(2) and (not op(1) and op(0));
	op_mux1(1) <= orOut(1) and (not op(1) and op(0));
	op_mux1(0) <= orOut(0) and (not op(1) and op(0));


	op_mux2(7) <= addOut(7) and (op(1) and not op(0));
	op_mux2(6) <= addOut(6) and (op(1) and not op(0));
	op_mux2(5) <= addOut(5) and (op(1) and not op(0));
	op_mux2(4) <= addOut(4) and (op(1) and not op(0));
	op_mux2(3) <= addOut(3) and (op(1) and not op(0));
	op_mux2(2) <= addOut(2) and (op(1) and not op(0));
	op_mux2(1) <= addOut(1) and (op(1) and not op(0));
	op_mux2(0) <= addOut(0) and (op(1) and not op(0));

	op_mux3(7) <= less(7) and ( op(1) and  op(0));
	op_mux3(6) <= less(6) and ( op(1) and  op(0));
	op_mux3(5) <= less(5) and ( op(1) and  op(0));
	op_mux3(4) <= less(4) and ( op(1) and  op(0));
	op_mux3(3) <= less(3) and ( op(1) and  op(0));
	op_mux3(2) <= less(2) and ( op(1) and  op(0));
	op_mux3(1) <= less(1) and ( op(1) and  op(0));
	op_mux3(0) <= less(0) and ( op(1) and  op(0));

    i_s(7) <= (op_mux3(7) or op_mux2(7)) or (op_mux1(7) or op_mux0(7));
	i_s(6) <= (op_mux3(6) or op_mux2(6)) or (op_mux1(6) or op_mux0(6));
	i_s(5) <= (op_mux3(5) or op_mux2(5)) or (op_mux1(5) or op_mux0(5));
	i_s(4) <= (op_mux3(4) or op_mux2(4)) or (op_mux1(4) or op_mux0(4));
	i_s(3) <= (op_mux3(3) or op_mux2(3)) or (op_mux1(3) or op_mux0(3));
	i_s(2) <= (op_mux3(2) or op_mux2(2)) or (op_mux1(2) or op_mux0(2));
	i_s(1) <= (op_mux3(1) or op_mux2(1)) or (op_mux1(1) or op_mux0(1));
	i_s(0) <= (op_mux3(0) or op_mux2(0)) or (op_mux1(0) or op_mux0(0));



	s <= i_s;
    o_f <= i_of;
	z <= i_z;

end struc;