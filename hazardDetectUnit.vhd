LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Hazard Detection Unit ***(new)***
    --            |-> inputs: 
    --              - enabled by ID_EX_MemRead 
    --              - ID_EX_reg_Rt (5 bits)
    --              - IF_ID_reg_Rs (5 bits)
    --              - IF_ID_reg-Rt (5 bits)
    --            |-> outputs:
    --              - i_HDU_mux_cont (controls the mux)
    --              - IF_ID_Write (controls write to IF_ID_buffer)
    --              - i_PCwrite (controls write to PC)
    --            |-> logic:
    --              - If(ID_EX_MemRead and ((ID_EX_reg_Rt == IF_ID_reg_Rs) or (ID_EX_reg_Rt == IF_ID_reg_Rt)))
    --              => i_HDU_mux_cont = 1
    --              => IF_ID_Write = 0
    --              => i_PCwrite = 0

entity hazardDetectUnit is
    port (
        ID_EX_MemRead : in std_logic;
        ID_EX_reg_Rt, IF_ID_reg_Rs, IF_ID_reg_Rt : in std_logic_vector(4 downto 0);
        HDU_mux_cont, IF_ID_Write, PCwrite : out std_logic
    );
end entity hazardDetectUnit;

architecture rtl of hazardDetectUnit is
    
    -- signal declarations:
    signal i_HDU_mux_cont, i_IF_ID_Write, i_PCwrite : std_logic;
    signal eq1, eq2, eq_final, Q : std_logic;

    -- component declarations:
    component comparator_5bit IS
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(4 downto 0);
		o_GT, o_LT, o_EQ	: OUT	STD_LOGIC);
END component;


begin

    Comparator1 : comparator_5bit port map (
        i_Ai => ID_EX_reg_Rt, i_Bi => IF_ID_reg_Rs,
        o_GT => open, o_LT => open, o_EQ => eq1
    );

    Comparator2 : comparator_5bit port map (
        i_Ai => ID_EX_reg_Rt, i_Bi => IF_ID_reg_Rt,
        o_GT => open, o_LT => open, o_EQ => eq2
    );

    eq_final <= eq1 or eq2;
    Q <= ID_EX_MemRead and eq_final;

    i_HDU_mux_cont <= Q;
    i_IF_ID_Write <= not Q;
    i_PCwrite <= not Q;

    HDU_mux_cont <= i_HDU_mux_cont;
    IF_ID_Write <= i_IF_ID_Write;
    PCwrite <= i_PCwrite;

    

end architecture;