library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This is the top level entity for the Pipelined Processor project

entity pipelinedProc is 
    port (
        GClock, GReset: in STD_LOGIC;
        valueSelect : in STD_LOGIC_VECTOR(2 downto 0);
        InstrSelect : in STD_LOGIC_VECTOR(2 downto 0);
        muxOut : out STD_LOGIC_VECTOR(7 downto 0);
        instructionOut : out STD_LOGIC_VECTOR(31 downto 0);
        BranchOut, ZeroOut, MemWriteOut,RegWriteOut : out STD_LOGIC
        );

end pipelinedProc;

architecture structural of pipelinedProc is 

    -- signal declarations
    signal i_muxOut : std_logic_vector(7 downto 0);
    signal i_instructionOut : std_logic_vector(31 downto 0);
    signal i_BranchOut, i_ZeroOut, i_MemWriteOut, i_RegWriteOut : std_logic;
    signal i_PC, i_ALUResult, i_ReadData1, i_ReadData2, i_WriteData, i_other : std_logic_vector(7 downto 0);
    signal i_RegDst, i_MemtoReg, i_MemRead,
           i_ALUOp1, i_ALUOp0, i_ALUSrc, i_Jump : std_logic;

    -- InstructionOut info
    signal i_instructionOut1 : std_logic_vector(31 downto 0);
    -- rest of the instructionOut signals declared in their pipelines

    -- IF signals
    signal i_PC_plus4 : std_logic_vector(7 downto 0);
    signal br_targ_addr : std_logic_vector(7 downto 0);
    signal br_control : std_logic;
    signal br_result : std_logic_vector(7 downto 0);
    signal i_PCReg_in : std_logic_vector(7 downto 0);
    signal i_PCwrite, i_PCwrite_bar : std_logic;

    -- IF/ID signals:
    signal IF_Flush : std_logic;
    signal IF_ID_Write : std_logic;
    signal IF_ID_pc_plus_4 : std_logic_vector(7 downto 0);
    signal IF_ID_instructionOut2 : std_logic_vector(31 downto 0);
    -- subcomponents of IF/ID:
    signal IF_ID_reg_Rs, IF_ID_reg_Rt, IF_ID_reg_Rd : std_logic_vector(4 downto 0);

    -- ID signals:
    signal jmp_targ_addr : std_logic_vector(7 downto 0);
    signal br_targ_offset : std_logic_vector(7 downto 0);
    signal sign_trunc_out : std_logic_vector(7 downto 0);
    signal RF_readReg1, RF_readReg2, RF_writeReg : std_logic_vector(4 downto 0);
    signal RF_ReadData1, RF_ReadData2 : std_logic_vector(7 downto 0);
    signal i_HDU_mux_cont : std_logic;
    signal i_send_nop : std_logic;
    signal comparator_rs_rt_equal : std_logic;
    signal i_control_signals : std_logic_vector(7 downto 0);
    signal control_mux_out : std_logic_vector(7 downto 0);

    -- ID/EX signals:
    signal ID_EX_MemRead : std_logic;
    signal ID_EX_reg_Rt : std_logic_vector(4 downto 0);
    signal ID_EX_cont_out, ID_EX_ReadData1_out, ID_EX_ReadData2_out, ID_EX_SignTrunc_out : std_logic_vector(7 downto 0);
    signal ID_EX_reg_Rs_out, ID_EX_reg_Rt_out, ID_EX_reg_Rd_out : std_logic_vector(4 downto 0);
    signal ID_EX_instructionOut3_out : std_logic_vector(31 downto 0);

    -- EX signals: 
    signal i_ALU_cont : std_logic_vector(3 downto 0);
    signal ALU_in1, ALU_in2, EX_ALUResult, EX_writeData : std_logic_vector(7 downto 0);
    signal i_Fwd_A, i_Fwd_B : std_logic_vector(1 downto 0);
    signal EX_RegRd_out : std_logic_vector(4 downto 0);

    -- EX/MEM signals:
    signal EX_MEM_ALUResult, EX_MEM_WriteData : std_logic_vector(7 downto 0);
    signal EX_MEM_reg_Rd_out : std_logic_vector(4 downto 0);
    signal EX_MEM_cont_out : std_logic_vector(7 downto 0);
    signal i_EX_MEM_cont_in : std_logic_vector(7 downto 0);
    signal EX_MEM_instructionOut4_out : std_logic_vector(31 downto 0);
    
    -- MEM signals
    signal MEM_ReadData : std_logic_vector(7 downto 0);

    -- MEM/WB signals:
    signal MEM_WB_reg_Rd_out : std_logic_vector(4 downto 0);
    signal MEM_WB_cont_out : std_logic_vector(7 downto 0);
    signal i_MEM_WB_cont_in : std_logic_vector(7 downto 0);
    signal MEM_WB_instructionOut5_out : std_logic_vector(31 downto 0);
    signal MEM_WB_ReadData_out : std_logic_vector(7 downto 0);
    signal MEM_WB_ALUResult_out :  std_logic_vector(7 downto 0);

    -- component declarations
    -- ------------------------------------------
    -- INSTRUCTION 
    -- Instruction Memory (32 bits, 256 instructions) (256x32) LPM_ROM function
    component instr_mem IS
        PORT (
            address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock		: IN STD_LOGIC;
            q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END component;

    -- ------------------------------------------
    -- MUX
    -- 8x2x1 MUX (memory mux, ALU mux, branch mux, jump mux)
    component mux_8bit_2x1 is
        port (
            data_0, data_1 : in std_logic_vector(7 downto 0);
            sel : in std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- 5x2x1 MUX (Register Write MUX)
    component mux_5bit_2x1 is
        port (
            data_0, data_1 : in std_logic_vector(4 downto 0);
            sel : in std_logic;
            data_out : out std_logic_vector(4 downto 0)
        );
    end component;

    -- ------------------------------------------
    -- CONTROL
    -- Control Unit
    component ssp_control is
        port (
            instr : in std_logic_vector(5 downto 0);
            RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, 
            MemWrite, Branch, ALUOp1, ALUOp0, Jump : out std_logic
        );
    end component;

    -- ------------------------------------------
    -- REGISTERS
    -- Register File (8x8bit registers)
    component register_file_8x8 is
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
    end component;

    -- 8 bit register (PC Register)
    component reg_8bit is
        port(
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
            );
    end component;

    -- ------------------------------------------
    -- MAIN ALU SECTION

    -- 8+8 : PC Adder, ALU,  branch adder
    component ALU_8bit is
        port (   
            op : in std_logic_vector(3 downto 0);
            x : in std_logic_vector(7 downto 0);
            y : in std_logic_vector(7 downto 0);
            s : out std_logic_vector(7 downto 0);
            z : out std_logic;
            o_f : out std_logic
        );
    end component;

    -- ALU control unit
    component ALU_control is
        port (
            funct : in std_logic_vector(5 downto 0);
            ALU_op : in std_logic_vector(1 downto 0);
            ALU_cont : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Sign Truncate
    component sign_truncate_16to8 is
        port (
            data_in : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- ------------------------------------------
    -- RAM
    -- Data Memory (256x8) (LPM_RAM_DQ function)
    component main_mem IS
        PORT
        (
            address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock		: IN STD_LOGIC;
            data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            wren	: IN STD_LOGIC ;
            q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END component;

    -- ------------------------------------------
    -- OUTPUT MUX
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


    component IF_ID_Buffer is
        port (
            clk   : in std_logic;
            reset_bar : in std_logic;
            pc_plus_4_in : in std_logic_vector(7 downto 0);
            instructionOut2_in : in std_logic_vector(31 downto 0);
            IF_Flush : in std_logic;
            IF_ID_Write : in std_logic;
            pc_plus_4_out : out std_logic_vector(7 downto 0);
            instructionOut2_out : out std_logic_vector(31 downto 0) 
        );
    end component;

    component comparator_8bit IS
        PORT(
            i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
            o_GT, o_LT, o_EQ	: OUT	STD_LOGIC);
    END component;


    component hazardDetectUnit is
        port (
            ID_EX_MemRead : in std_logic;
            ID_EX_reg_Rt, IF_ID_reg_Rs, IF_ID_reg_Rt : in std_logic_vector(4 downto 0);
            HDU_mux_cont, IF_ID_Write, PCwrite : out std_logic
        );
    end component;

    component ID_EX_Buffer is
        port (
            clk   : in std_logic;
            reset_bar : in std_logic;
            ID_EX_cont_in, ID_EX_ReadData1_in, ID_EX_ReadData2_in, ID_EX_SignTrunc_in : in std_logic_vector(7 downto 0);
            ID_EX_reg_Rs_in, ID_EX_reg_Rt_in, ID_EX_reg_Rd_in : in std_logic_vector(4 downto 0);
            ID_EX_instructionOut3_in : in std_logic_vector(31 downto 0);
            ID_EX_cont_out, ID_EX_ReadData1_out, ID_EX_ReadData2_out, ID_EX_SignTrunc_out : out std_logic_vector(7 downto 0);
            ID_EX_reg_Rs_out, ID_EX_reg_Rt_out, ID_EX_reg_Rd_out : out std_logic_vector(4 downto 0);
            ID_EX_instructionOut3_out : out std_logic_vector(31 downto 0)
        );
    end component;

    component mux_8bit_4x1 is
        port (
            data_0, data_1, data_2, data_3 : in std_logic_vector(7 downto 0);
            sel : in std_logic_vector(1 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component forwardingUnit is
        port (
            ID_EX_reg_Rs, ID_EX_reg_Rt, EX_MEM_reg_Rd, MEM_WB_reg_Rd : in std_logic_vector(4 downto 0);
            EX_MEM_RegWriteOut, MEM_WB_RegWriteOut : in std_logic;
            Fwd_A, Fwd_B : out std_logic_vector(1 downto 0)
        );
    end component;

    component EX_MEM_Buffer is
        port (
            clk   : in std_logic;
            reset_bar : in std_logic;
            EX_MEM_cont_in, EX_MEM_ALUResult_in, EX_MEM_WriteData_in : in std_Logic_vector(7 downto 0);
            EX_MEM_reg_Rd_in : in std_Logic_vector(4 downto 0);
            EX_MEM_instructionOut4_in : in std_logic_vector(31 downto 0);
            EX_MEM_cont_out, EX_MEM_ALUResult_out, EX_MEM_WriteData_out : out std_Logic_vector(7 downto 0);
            EX_MEM_reg_Rd_out : out std_Logic_vector(4 downto 0);
            EX_MEM_instructionOut4_out : out std_logic_vector(31 downto 0)        
        );
    end component;

    component MEM_WB_Buffer is
        port (
            clk   : in std_logic;
            reset_bar : in std_logic;
            MEM_WB_cont_in, MEM_WB_ReadData_in, MEM_WB_ALUResult_in : in std_Logic_vector(7 downto 0);
            MEM_WB_reg_Rd_in : in std_Logic_vector(4 downto 0);
            MEM_WB_instructionOut5_in : in std_logic_vector(31 downto 0);
            MEM_WB_cont_out, MEM_WB_ReadData_out, MEM_WB_ALUResult_out : out std_Logic_vector(7 downto 0);
            MEM_WB_reg_Rd_out : out std_Logic_vector(4 downto 0);
            MEM_WB_instructionOut5_out : out std_logic_vector(31 downto 0)        
        );
    end component;

    component instructionOutRegister is
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
    end component;

begin
    -- component instantiations

    ---------------------------------------------
    -- IF STAGE:
    -- BranchMux (0: PC+4, 1: brTargAddr) 
    -- JumpMux (0: BranchResult, 1: Jump targ addr) 
    -- PC Register ***(add i_PCwrite signal)***
    -- PC+4 Adder 

    -- Branch MUX
    BranchMUX : mux_8bit_2x1 port map (
        data_0 => i_PC_plus4, data_1 => br_targ_addr,
        sel => br_control,
        data_out => br_result
    );

    -- Jump MUX
    JumpMUX : mux_8bit_2x1 port map (
        data_0 => br_result, data_1 => jmp_targ_addr,
        sel => i_Jump,
        data_out => i_PCReg_in
    );

    i_PCwrite_bar <= not i_PCwrite;

    -- PC Register 
    PC_register : reg_8bit port map (
        reset_bar => GReset, load_bar => i_PCwrite_bar,
        clk => GClock,
        data_in => i_PCReg_in,
        data_out => i_PC
    );

    -- PC Adder
    PC_4_Adder : ALU_8bit port map (
        op => "0010",
        x => i_PC,
        y => "00000100",
        s => i_PC_plus4,
        z => open,
        o_f => open
    );

    -- Instruction Memory (ROM)
    ROM : instr_mem port map (
        address => i_PC,
        clock => GClock,
        q => i_instructionOut1
    );

    ---------------------------------------------
    -- IF/ID Buffer (IF_ID_Buffer)
    --- regs:
    --- 1) PC+4 (8 bits)
    --- 2) Instruction (32 bits) (i_InstructionOut2)
    --- inputs signals:
    --- 1) IF_Flush signal
    --- 2) IF_ID_Write signal

    IF_ID_Buffer_entity : IF_ID_Buffer port map (
        clk => GClock,
        reset_bar => GReset,
        pc_plus_4_in => i_PC_plus4, 
        instructionOut2_in => i_instructionOut1, 
        IF_Flush => IF_Flush,
        IF_ID_Write => IF_ID_Write,
        pc_plus_4_out => IF_ID_pc_plus_4,
        instructionOut2_out => IF_ID_instructionOut2
    );

    IF_ID_reg_Rs <= IF_ID_instructionOut2(25 downto 21);
    IF_ID_reg_Rt <= IF_ID_instructionOut2(20 downto 16);
    IF_ID_reg_Rd <= IF_ID_instructionOut2(15 downto 11);

    ---------------------------------------------
    -- ID STAGE:
    -- calculate jump target address : lowest 6 bits of the address (IF_ID_instructionOut2(5..0)) & "00" (shifted left by 2)
    jmp_targ_addr <= IF_ID_instructionOut2(5 downto 0) & "00";

    -- Register file (RegWrite comes from MEM/WB)
    registerFile : register_file_8x8 port map (
        clk => GClock,
        reset_bar => GReset,
        read_reg1 => RF_readReg1, read_reg2 => RF_readReg2, write_reg => RF_writeReg,
        write_data => i_WriteData,
        wr => MEM_WB_cont_out(1),
        read_data1 => RF_ReadData1,
        read_data2 => RF_ReadData2
    );

    RF_readReg1 <= IF_ID_instructionOut2(25 downto 21);
    RF_readReg2 <= IF_ID_instructionOut2(20 downto 16);
    RF_writeReg <= MEM_WB_reg_Rd_out;
    i_ReadData1 <= RF_ReadData1;
    i_ReadData2 <= RF_ReadData2;

    -- Branch adder
    BranchAdder : ALU_8bit port map (
        op => "0010",
        x => IF_ID_pc_plus_4,
        y => br_targ_offset,
        s => br_targ_addr,
        z => open,
        o_f => open
    );

    -- sign truncate
    sign_truncate : sign_truncate_16to8 port map (
        data_in => IF_ID_instructionOut2(15 downto 0),
        data_out => sign_trunc_out
    );

    -- Branch shift left
    br_targ_offset <= sign_trunc_out(5 downto 0) & "00";
    br_control <= i_BranchOut and comparator_rs_rt_equal;

    -- Comparator_rs_rt ***(new, equal output replaces zero status signal)***
    Comparator_rs_rt : comparator_8bit port map (
        i_Ai => RF_ReadData1, i_Bi => RF_ReadData2,
        o_GT => open, o_LT => open, o_EQ => comparator_rs_rt_equal
    );

    -- Control Unit 
    --   non-Mux  |-> i_BranchOut
    --   non_mux  |-> i_Jump         
    --            ***(br_control <= comparator_rt_rt_equal AND i_BranchOut , doesn't go to Control_mux)
    --            ***(new IF_Flush cont. signal but it doesn't go to Control_MUX)
    --            |-> IF_Flush <= br_control
    --
    --            ***(Rest of the signals go to Control_MUX)
    --        EX  |-> i_Reg_Dst
    --            |-> i_ALUOp1
    --            |-> i_ALUOp0
    --            |-> i_ALUSrc
    --        MEM |-> i_MemRead
    --            |-> i_MemWriteOut
    --        WB  |-> i_RegWriteOut
    --            |-> i_MemtoReg

    controlUnit : ssp_control port map (
        instr => IF_ID_instructionOut2(31 downto 26),
        RegDst => i_RegDst, ALUSrc => i_ALUSrc, MemtoReg => i_MemtoReg, RegWrite => i_RegWriteOut, 
        MemRead => i_MemRead, MemWrite => i_MemWriteOut, Branch => i_BranchOut, ALUOp1 => i_ALUOp1, ALUOp0 => i_ALUOp0, Jump => i_Jump
    );

    IF_Flush <= br_control or i_Jump;

    i_control_signals <= i_RegDst & i_ALUOp1 & i_ALUOp0 & i_ALUSrc & i_MemRead & i_MemWriteOut & i_RegWriteOut & i_MemtoReg;

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
    HDU : hazardDetectUnit port map (
        ID_EX_MemRead => ID_EX_MemRead,
        ID_EX_reg_Rt => ID_EX_reg_Rt, IF_ID_reg_Rs => IF_ID_reg_Rs, IF_ID_reg_Rt => IF_ID_reg_Rt,
        HDU_mux_cont => i_HDU_mux_cont, IF_ID_Write => IF_ID_Write, PCwrite => i_PCwrite
    );

    i_send_nop <= i_HDU_mux_cont or br_control;

    -- *** when branch is taken : br_control = 1, IF_Flush = 1
    -- *** when jump is called : IF_Flush = 1
    -- *** so ==> IF_Flush <= br_control or i_Jump
    -- *** when HDU is enabled  : i_HDU_mux_cont = 1, IF_ID_Write = 0, i_PCwrite = 0
    -- *** i_send_nop <= br_control or i_HDU_mux_cont

    -- Control_MUX ***(new)*** (8bit_2x1_mux)
    --            |-> data0 : Control unit's necessary signals
    --            |-> data1 : "00000000"
    --            |-> sel   : i_send_nop ***(new signal)***
    --            |-> data_out : control_mux_out 
    ControlMux : mux_8bit_2x1 port map (
        data_0 => i_control_signals, data_1 => "00000000",
        sel => i_send_nop,
        data_out => control_mux_out
    );

    ---------------------------------------------
    -- ID/EX Buffer (ID_EX_Buffer)
    --- regs:
    --- 1) ID_EX_EX &  ID_EX_MEM & ID_EX_WB (8bit reg)
    --- 2) ID_EX_ReadData1 (8bit reg)
    --- 3) ID_EX_ReadData2 (8bit reg)
    --- 4) ID_EX_SignTrunc (8bit reg)
    --- 5) ID_EX_reg_Rs (5bit reg)
    --- 6) ID_EX_reg_Rt (5bit reg)
    --- 7) ID_EX_reg_Rd (5bit reg)
    --- 8) i_InstructionOut3

    ID_EX_Buffer_entity : ID_EX_Buffer port map (
        clk => GClock,
        reset_bar => GReset,
        ID_EX_cont_in => control_mux_out, 
        ID_EX_ReadData1_in => i_ReadData1, 
        ID_EX_ReadData2_in => i_ReadData2, 
        ID_EX_SignTrunc_in => sign_trunc_out,
        ID_EX_reg_Rs_in => IF_ID_reg_Rs, 
        ID_EX_reg_Rt_in => IF_ID_reg_Rt, 
        ID_EX_reg_Rd_in => IF_ID_reg_Rd, 
        ID_EX_instructionOut3_in => IF_ID_instructionOut2,
        ID_EX_cont_out => ID_EX_cont_out, 
        ID_EX_ReadData1_out => ID_EX_ReadData1_out, 
        ID_EX_ReadData2_out => ID_EX_ReadData2_out, 
        ID_EX_SignTrunc_out => ID_EX_SignTrunc_out,
        ID_EX_reg_Rs_out => ID_EX_reg_Rs_out, 
        ID_EX_reg_Rt_out => ID_EX_reg_Rt_out, 
        ID_EX_reg_Rd_out => ID_EX_reg_Rd_out,
        ID_EX_instructionOut3_out => ID_EX_instructionOut3_out
    );
  
    ---------------------------------------------
    -- EX STAGE:

    -- ALUContrl:
    --     funct : ID_EX_SignTrunc(5 downto 0)
    --     ALU_op => ID_EX_ALUOp1 & ID_EX_ALUOp0,
    --     ALU_cont => i_ALU_cont
    ALUControl : ALU_control port map (
        funct => ID_EX_SignTrunc_out(5 downto 0),
        ALU_op => ID_EX_cont_out(6 downto 5),
        ALU_cont => i_ALU_cont
    );

    -- ALU_main
    --      op: i_ALU_cont 
    --      x : ALU_in1 ***(new signal)***
    --      y : ALU_in2 ***(new signal)***
    --      s : EX_ALUResult ***(new signal)***
    --      z : i_ZeroOut
    --      o_f => open
    ALU_main : ALU_8bit port map (
        op => i_ALU_cont,
        x => ALU_in1,
        y => ALU_in2,
        s => EX_ALUResult,
        z => i_ZeroOut,
        o_f => open
    );

    -- FwdA_mux ***(new)*** (8bit 4x1 mux) (3 inputs)
    --            |-> inputs / outputs
    --              - data0 : ID_EX_ReadData1 (8bits)
    --              - data1 : i_WriteData
    --              - data2 : EX_MEM_ALUResult 
    --              - sel   : i_Fwd_A
    --              - data_out : ALU_in1 ***(new signal)***
    FwdA_mux: mux_8bit_4x1 port map (
        data_0 => ID_EX_ReadData1_out, 
        data_1 => i_WriteData, 
        data_2 => EX_MEM_ALUResult, 
        data_3 => "00000000",
        sel => i_Fwd_A,
        data_out => ALU_in1
    );
    

    -- FwdB_mux ***(new)*** (8bit 4x1 mux) (3 inputs)
    --            |-> inputs / outputs
    --              - data0 : ID_EX_ReadData2 (8bits)
    --              - data1 : i_WriteData
    --              - data2 : EX_MEM_ALUResult 
    --              - sel   : i_Fwd_B
    --              - data_out : EX_writeData (old name: i_ReadData2)
    FwdB_mux: mux_8bit_4x1 port map (
        data_0 => ID_EX_ReadData2_out, 
        data_1 => i_WriteData, 
        data_2 => EX_MEM_ALUResult, 
        data_3 => "00000000",
        sel => i_Fwd_B,
        data_out => EX_writeData
    );

    -- ALU_mux
    --            |-> inputs / outputs
    --              - data0 : EX_writeData (old name: i_ReadData2)
    --              - data1 : ID_EX_SignTrunc
    --              - sel   : ID_EX_ALUSrc
    --              - data_out : ALU_in2 ***(new signal)***
    ALU_mux : mux_8bit_2x1 port map (
        data_0 => EX_writeData, data_1 => ID_EX_SignTrunc_out,
        sel => ID_EX_cont_out(4),
        data_out => ALU_in2
    );

    -- registerFileMux ***(modify)*** (8bit_2x1_mux)
    --            |-> inputs / outputs
    --              - data0 : ID_EX_reg_Rt
    --              - data1 : ID_EX_reg_Rd
    --              - sel   : ID_EX_Reg_Dst
    --              - data_out : EX_RegRd_out
    registerFileMUX : mux_5bit_2x1 port map (
        data_0 => ID_EX_reg_Rt_out, data_1 => ID_EX_reg_Rd_out,
        sel => ID_EX_cont_out(7),
        data_out => EX_RegRd_out
    );         

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
    fwdUnit : forwardingUnit port map (
        ID_EX_reg_Rs => ID_EX_reg_Rs_out, 
        ID_EX_reg_Rt => ID_EX_reg_Rt_out, 
        EX_MEM_reg_Rd => EX_MEM_reg_Rd_out, 
        MEM_WB_reg_Rd => MEM_WB_reg_Rd_out,  
        EX_MEM_RegWriteOut => EX_MEM_cont_out(1), 
        MEM_WB_RegWriteOut => MEM_WB_cont_out(1),
        Fwd_A => i_Fwd_A, Fwd_B => i_Fwd_B
    );

    ---------------------------------------------
    -- EX/MEM Buffer (EX_MEM_Buffer)
    --- regs: 
    --- 1) EX_MEM_EX (null) &  EX_MEM_MEM & EX_MEM_WB (8bit reg)
    --- 2) EX_MEM_ALUResult (8bit)
    --- 3) EX_MEM_writeData ***(new signal)***
    --- 4) EX_MEM_reg_Rd (5bit)
    --- 5) i_InstructionOut4
    EX_MEM_Buffer_entity : EX_MEM_Buffer port map (
        clk => GClock,
        reset_bar => GReset,
        EX_MEM_cont_in => i_EX_MEM_cont_in, 
        EX_MEM_ALUResult_in => EX_ALUResult, 
        EX_MEM_WriteData_in => EX_writeData,
        EX_MEM_reg_Rd_in => EX_RegRd_out,
        EX_MEM_instructionOut4_in => ID_EX_instructionOut3_out,
        EX_MEM_cont_out => EX_MEM_cont_out,
        EX_MEM_ALUResult_out => EX_MEM_ALUResult,
        EX_MEM_WriteData_out => EX_MEM_WriteData,
        EX_MEM_reg_Rd_out => EX_MEM_reg_Rd_out,
        EX_MEM_instructionOut4_out => EX_MEM_instructionOut4_out
    );

    i_EX_MEM_cont_in <= "0000" & ID_EX_cont_out(3 downto 0);

    ---------------------------------------------
    -- MEM STAGE: 

    -- RAM:
    --      address => EX_MEM_ALUResult
    --      clock => GClock
    --      data => EX_MEM_writeData
    --      wren => EX_MEM_MemWriteOut
    --      ren => EX_MEM_MemRead ***(add signal and functionality)***
    --      q => EX_ReadData ***(new signal)***
    RAM : main_mem port map (
        address => EX_MEM_ALUResult,
        clock => GClock,
        data => EX_MEM_WriteData,
        wren => EX_MEM_cont_out(2),
        q => MEM_ReadData
    );
    
    ---------------------------------------------
    -- MEM/WB Buffer (MEM_WB_Buffer)
    --- regs: 
    --- 1) MEM_WB_EX (null) &  MEM_WB_MEM (null) & MEM_WB_WB (8bit reg)
    --- 2) MEM_WB_ReadData (8bit)
    --- 3) MEM_WB_ALUResult (8bit)
    --- 4) MEM_WB_reg_Rd (5bit)
    --- 5) i_InstructionOut5
    MEM_WB_Buffer_entity : MEM_WB_Buffer port map (
        clk => GClock,
        reset_bar => GReset,
        MEM_WB_cont_in => i_MEM_WB_cont_in, 
        MEM_WB_ReadData_in => MEM_ReadData, 
        MEM_WB_ALUResult_in => EX_MEM_ALUResult,
        MEM_WB_reg_Rd_in => EX_MEM_reg_Rd_out,
        MEM_WB_instructionOut5_in => EX_MEM_instructionOut4_out,
        MEM_WB_cont_out => MEM_WB_cont_out,
        MEM_WB_ReadData_out => MEM_WB_ReadData_out,
        MEM_WB_ALUResult_out => MEM_WB_ALUResult_out,
        MEM_WB_reg_Rd_out => MEM_WB_reg_Rd_out,
        MEM_WB_instructionOut5_out => MEM_WB_instructionOut5_out
    );

    i_MEM_WB_cont_in <= "000000" & EX_MEM_cont_out(1 downto 0);

    ---------------------------------------------
    -- WB STAGE: 
    -- memoryMUX 
    --      data_0 => MEM_WB_ALUResult
    --      data_1 => MEM_WB_ReadData
    --      sel => MEM_WB_MemtoReg
    --      data_out => i_WriteData
    MemoryMUX : mux_8bit_2x1 port map (
        data_0 => MEM_WB_ALUResult_out, data_1 => MEM_WB_ReadData_out,
        sel => MEM_WB_cont_out(0),
        data_out => i_WriteData
    );

    instr_out_reg : instructionOutRegister port map (
        reset_bar => GReset,
        clk => GClock,
        sel => InstrSelect, 
        data_in0 => i_instructionOut1,
        data_in1 => IF_ID_instructionOut2,
        data_in2 => ID_EX_instructionOut3_out,
        data_in3 => EX_MEM_instructionOut4_out,
        data_in4 => MEM_WB_instructionOut5_out,
        data_out => i_instructionOut
    );

    -- ------------------------------------------
    -- OUTPUT MUX
    OutputMUX : mux_8bit_8x1 port map (
        sel => valueSelect,
        data_in0 => i_PC,
        data_in1 => i_ALUResult,
        data_in2 => i_ReadData1,
        data_in3 => i_ReadData2,
        data_in4 => i_WriteData,
        data_in5 => i_other,
        data_in6 => i_other,
        data_in7 => i_other,
        data_out => i_muxOut
    );

    i_other <= '0' & i_RegDst & i_Jump & i_MemRead & i_MemtoReg & i_ALUOp1 & i_ALUOp0 & i_ALUSrc;

    -- output driver

    muxOut <= i_muxOut;
    instructionOut <= i_instructionOut;
    BranchOut <= i_BranchOut;
    ZeroOut <= i_ZeroOut;
    MemWriteOut <= i_MemWriteOut;
    RegWriteOut <= i_RegWriteOut;

end structural;