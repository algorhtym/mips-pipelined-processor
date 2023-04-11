library verilog;
use verilog.vl_types.all;
entity pipelinedProc_vlg_sample_tst is
    port(
        GClock          : in     vl_logic;
        GReset          : in     vl_logic;
        InstrSelect     : in     vl_logic_vector(2 downto 0);
        valueSelect     : in     vl_logic_vector(2 downto 0);
        sampler_tx      : out    vl_logic
    );
end pipelinedProc_vlg_sample_tst;
