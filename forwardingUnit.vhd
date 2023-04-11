library ieee;
use ieee.std_logic_1164.all;


-- Forwarding Unit: ***(new)***
    --      inputs: 
    --      - ID_EX_reg_Rs
    --      - ID_EX_ref_Rt
    --      - EX_MEM_reg_Rd
    --      - MEM_WB_reg_Rd
    --      - EX_MEM_RegWriteOut
    --      - MEM_WB_RegWriteOut
    --      outputs:
    --      - i_Fwd_A, i_Fwd_B

entity forwardingUnit is
    port (
        ID_EX_reg_Rs, ID_EX_reg_Rt, EX_MEM_reg_Rd, MEM_WB_reg_Rd : in std_logic_vector(4 downto 0);
        EX_MEM_RegWriteOut, MEM_WB_RegWriteOut : in std_logic;
        Fwd_A, Fwd_B : out std_logic_vector(1 downto 0)
    );
end entity forwardingUnit;

architecture rtl of forwardingUnit is
    
    -- signal declarations
    signal i_FwdA, i_FwdB : std_logic;
    signal eq1, eq2, eq3, eq4 : std_logic;
    signal eqA, eqB : std_logic;
    signal i_EX_MEM_reg_Rd, i_MEM_WB_reg_Rd : std_logic_vector(4 downto 0);
    signal type1, type2, type3, type4 : std_logic;

    signal i_fwd_A_out, i_fwd_B_out : std_logic_vector(1 downto 0);

    component comparator_5bit IS
        PORT(
            i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(4 downto 0);
            o_GT, o_LT, o_EQ	: OUT	STD_LOGIC);
    END component;

begin

    Comparator_A : comparator_5bit port map (
        i_Ai => EX_MEM_reg_Rd, i_Bi => "00000",
        o_GT => open, o_LT => open, o_EQ => eqA
    );

    Comparator_B : comparator_5bit port map (
        i_Ai => MEM_WB_reg_Rd, i_Bi => "00000",
        o_GT => open, o_LT => open, o_EQ => eqB
    );

    Comparator_1 : comparator_5bit port map (
        i_Ai => EX_MEM_reg_Rd, i_Bi => ID_EX_reg_Rs,
        o_GT => open, o_LT => open, o_EQ => eq1
    );

    Comparator_2 : comparator_5bit port map (
        i_Ai => EX_MEM_reg_Rd, i_Bi => ID_EX_reg_Rt,
        o_GT => open, o_LT => open, o_EQ => eq2
    );

    Comparator_3 : comparator_5bit port map (
        i_Ai => MEM_WB_reg_Rd, i_Bi => ID_EX_reg_Rs,
        o_GT => open, o_LT => open, o_EQ => eq3
    );

    Comparator_4 : comparator_5bit port map (
        i_Ai => MEM_WB_reg_Rd, i_Bi => ID_EX_reg_Rt,
        o_GT => open, o_LT => open, o_EQ => eq4
    );

    i_FwdA <= EX_MEM_RegWriteOut and (not eqA);
    i_FwdB <= MEM_WB_RegWriteOut and (not eqB);

    type1 <= i_FwdA and eq1;
    type3 <= i_FwdA and eq3;

    type2 <= i_FwdB and eq2;
    type4 <= i_FwdB and eq4;

    i_fwd_A_out(1) <= (not type1) and type3; 
    i_fwd_A_out(0) <= type1;

    i_fwd_B_out(1) <= (not type2) and type4;
    i_fwd_B_out(0) <= type2;

    
    Fwd_A <= i_fwd_A_out;
    Fwd_B <= i_fwd_B_out;

end architecture;