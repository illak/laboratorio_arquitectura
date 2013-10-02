library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;


entity pipeline_tb is
end entity;

architecture TB of pipeline_tb is
	component pipeline
	port(
		op: in std_logic_vector(5 downto 0);
		funct: in std_logic_vector(5 downto 0);

		dump : in std_logic;

		pc : out std_logic_vector(31 downto 0);
		instr : out std_logic_vector(31 downto 0);

		reset : in std_logic;
		clk : in std_logic
	);
	end component;


	signal op, funct: std_logic_vector(5 downto 0);
	signal pc, instr: std_logic_vector(31 downto 0);
	signal dump, reset, clk: std_logic;

	begin
	dut: pipeline port map(
				op => op,
				funct => funct,
				dump => dump,
				pc => pc,
				instr => instr,
				reset => reset,
				clk => clk
				);


	process begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process;

	process begin
		--01094020  (add $t0 $t0 $t1)

		--en binario:
		--0000 0001 0000 1001 0100 0000 0010 0000

		reset <= '1';
        wait for 5 ns;
        reset <= '0';
		op <= "000000";
		funct <= "100000";
		wait for 5 ns;
		dump <= '1';
		wait for 100 ns;
	end process;

end TB;
