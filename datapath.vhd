library ieee;
    use ieee.std_logic_1164.all;

entity datapath is
    port (
        MemToReg : in std_logic;
        MemWrite : in std_logic;
        Branch : in std_logic;
        AluSrc : in std_logic;
        RegDst : in std_logic;
        RegWrite : in std_logic;
        Jump : in std_logic;
        AluControl : in std_logic_vector(2 downto 0);
        dump : in std_logic;
        pc : out std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0);
        reset : in std_logic;
        clk : in std_logic);
end entity;

architecture arq_datapath of datapath is
    component fetch
        port( 
            jumpM, PcSrcM, clk, reset: in std_logic;
            PcBranchM: in std_logic_vector(31 downto 0);
            InstrF, PCF, PCPlus4F: out std_logic_vector(31 downto 0));
    end component;
    component decode
        port(
            A3: in std_logic_vector(4 downto 0);
            InstrD, Wd3: in std_logic_vector(31 downto 0);
            RegWrite, clk: in std_logic;
            RtD, RdD: out std_logic_vector(4 downto 0);
            SignImmD, RD1D, RD2D: out std_logic_vector(31 downto 0));
    end component;
    component execute
        port(
            RD1E, RD2E, PCPlus4E, SignImmE: in std_logic_vector(31 downto 0);
            RtE, RdE: in std_logic_vector(4 downto 0);
            RegDst, AluSrc : in std_logic;
            AluControl: in std_logic_vector(2 downto 0);
            WriteRegE: out std_logic_vector(4 downto 0);
            ZeroE: out std_logic;
            AluOutE, WriteDataE, PCBranchE: out std_logic_vector(31 downto 0));
    end component;
    component memory
        port(
            AluOutM, WriteDataM: in std_logic_vector(31 downto 0);
            ZeroM, MemWrite, Branch, clk, dump: in std_logic;
            ReadDataM: out std_logic_vector(31 downto 0);
            PCSrcM: out std_logic);
    end component;
    component writeback
        port(
            AluOutW, ReadDataW: in std_logic_vector(31 downto 0);
            MemToReg: in std_logic;
            ResultW: out std_logic_vector(31 downto 0));
    end component;


signal PcBranchM_s, InstrF_s, PCF_s, PCPlus4F_s,
       InstrD_s, SignImmD_s, RD1D_s, RD2D_s,RD2E_s, RD1E_s,
       PCPlus4E_s, SignImmE_s, AluOutE_s, WriteDataE_s,
       PcBranchE_s, AluOutM_s, WriteDataM_s, ReadDataM_s,
       AluOutW_s, ReadDataW_s, ResultW_s, Wd3_s : std_logic_vector(31 downto 0);

signal Jump_s, ZeroE_s, ZeroM_s, PcSrcM_s : std_logic;

signal A3_s, RtD_s, RdD_s, RtE_s, RdE_s,
         WriteRegE_s: std_logic_vector(4 downto 0);

begin
    Fetch1: fetch port map(
                    jumpM     => Jump,
                    PcSrcM     => PCSrcM_s,
                    clk       => clk,
                    reset     => reset,
                    PcBranchM => PCBranchE_s,
                    InstrF    => InstrD_s,
                    PCF       => pc,
                    PCPlus4F  => PCPlus4E_s
                );
    Decode1: decode port map(
                        A3       => WriteRegE_s,
                        InstrD   => InstrF_s,
                        Wd3      => ResultW_s,
                        RegWrite => RegWrite,
                        clk      => clk,
                        RtD      => RtE_s,
                        RdD      => RdE_s,
                        SignImmD => SignImmE_s,
                        RD1D     => RD1E_s,
                        RD2D     => RD2E_s
                    );
    Execute1: execute port map(
                        RD1E       => RD1D_s,
                        RD2E       => RD2D_s,
                        PCPlus4E   => PCPlus4F_s,
                        SignImmE   => SignImmD_s,
                        RtE        => RtD_s,
                        RdE        => RdD_s,
                        RegDst     => RegDst,
                        AluSrc     => AluSrc,
                        AluControl => AluControl,
                        WriteRegE  => A3_s,
                        ZeroE      => ZeroM_s,
                        AluOutE    => AluOutM_s,
                        WriteDataE => WriteDataM_s,
                        PCBranchE  => PCBranchM_s
                    );
    Memory1: memory port map(
                        AluOutM    => AluOutE_s,
                        WriteDataM => WriteDataE_s,
                        ZeroM      => ZeroE_s,
                        MemWrite   => MemWrite,
                        Branch     => Branch,
                        clk        => clk,
                        dump       => dump,
                        ReadDataM  => ReadDataW_s,
                        PCSrcM     => PCSrcM_s --Posee el mismo nombre (posible conflicto futuro)
                    );
    WriteBack1: writeback port map(
                            AluOutW   => AluOutE_s,
                            ReadDataW => ReadDataM_s,
                            MemToReg  => MemToReg,
                            ResultW   => Wd3_s
                        );
instr <= instrD_s;
end arq_datapath;
