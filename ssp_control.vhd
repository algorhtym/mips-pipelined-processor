LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ssp_control is
    port (
        instr : in std_logic_vector(5 downto 0);
        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, 
        MemWrite, Branch, ALUOp1, ALUOp0, Jump : out std_logic
    );
end entity ssp_control;

architecture struc of ssp_control is

    -- signal declarations
    signal i_R_format, i_lw, i_sw, i_br, i_jmp : std_logic;
    signal i_RegDst, i_ALUSrc, i_MemtoReg, i_RegWrite, i_MemRead, 
           i_MemWrite, i_Branch, i_ALUOp1, i_ALUOp0, i_Jump : std_logic;
			  
	 signal r_type_in, lw_in, sw_in, br_in, j_in : std_logic_vector(5 downto 0);

    -- component declarations

    component and_6 is
        port (
            and6_in : in std_logic_vector(5 downto 0);
            and6_out : out std_logic
        );
    end component;

begin


    r_type_and6 : and_6 port map (
        and6_in => r_type_in,
        and6_out => i_R_format
    );

    lw_and6 : and_6 port map (
        and6_in => lw_in,
        and6_out => i_lw
    );

    sw_and6 : and_6 port map (
        and6_in => sw_in,
        and6_out => i_sw
    );

    beq_and6 : and_6 port map (
        and6_in => br_in,
        and6_out => i_br
    );

    j_and6 : and_6 port map (
        and6_in => j_in,
        and6_out => i_jmp
    );
	 
	 r_type_in <= (not instr(5) & not instr(4) & not instr(3) & not instr(2) & not instr(1) & not instr(0)); -- 000000
	 lw_in <= (instr(5) & not instr(4) & not instr(3) & not instr(2) & instr(1) & instr(0)); -- 1000011
	 sw_in <= (instr(5) & not instr(4) & instr(3) & not instr(2) & instr(1) & instr(0)); -- 101011
	 br_in <= (not instr(5) & not instr(4) & not instr(3) & instr(2) & not instr(1) & not instr(0)); -- 000100
     j_in <= (not instr(5) & not instr(4) & not instr(3) & not instr(2) & instr(1) & not instr(0)); -- 000010
	 

    i_RegDst <= i_R_format;
    i_ALUSrc <= i_lw or i_sw;
    i_MemtoReg <= i_lw;
    i_RegWrite <= i_R_format or i_lw;
    i_MemRead <= i_lw;
    i_MemWrite <= i_sw;
    i_Branch <= i_br;
    i_ALUOp1 <= i_R_format;
    i_ALUOp0 <= i_br;
    i_Jump <= i_jmp;


	RegDst <= i_RegDst;
    ALUSrc <= i_ALUSrc;
    MemtoReg <= i_MemtoReg;
    RegWrite <= i_RegWrite;
    MemRead <= i_MemRead;
    MemWrite <= i_MemWrite;
    Branch <= i_Branch;
    ALUOp1 <= i_ALUOp1;
    ALUOp0 <= i_ALUOp0;
    Jump <= i_Jump;




    

end architecture;