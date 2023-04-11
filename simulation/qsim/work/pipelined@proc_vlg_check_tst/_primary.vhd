library verilog;
use verilog.vl_types.all;
entity pipelinedProc_vlg_check_tst is
    port(
        BranchOut       : in     vl_logic;
        instructionOut  : in     vl_logic_vector(31 downto 0);
        MemWriteOut     : in     vl_logic;
        muxOut          : in     vl_logic_vector(7 downto 0);
        RegWriteOut     : in     vl_logic;
        ZeroOut         : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end pipelinedProc_vlg_check_tst;
