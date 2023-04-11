library verilog;
use verilog.vl_types.all;
entity pipelinedProc is
    port(
        GClock          : in     vl_logic;
        GReset          : in     vl_logic;
        valueSelect     : in     vl_logic_vector(2 downto 0);
        InstrSelect     : in     vl_logic_vector(2 downto 0);
        muxOut          : out    vl_logic_vector(7 downto 0);
        instructionOut  : out    vl_logic_vector(31 downto 0);
        BranchOut       : out    vl_logic;
        ZeroOut         : out    vl_logic;
        MemWriteOut     : out    vl_logic;
        RegWriteOut     : out    vl_logic
    );
end pipelinedProc;
