library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;


--package aludec_pkg is

entity aludec is
	port(
		funct	:in	std_logic_vector (5 downto 0);
		aluop	:in	std_logic_vector (1 downto 0);
		alucontrol:out std_logic_vector (2 downto 0)
	);
end entity;

architecture BH of aludec is
	
	function get_value (functv: in std_logic_vector(5 downto 0))
	return std_logic_vector is
	begin
		case functv is
			when "100000" => return "010";
			when "100010" => return "110";
			when "100100" => return "000";
			when "100101" => return "001";
			when "101010" => return "111";
			when others => return "000"; --por defecto??? preguntar!!
		end case;
	end get_value;

	begin
	process (funct, aluop) begin
		if (aluop = "00") then
		 alucontrol <= "010";
		elsif (aluop = "01") then
			alucontrol <= "110";
		elsif (aluop(1)='1') then
			alucontrol <= get_value(funct);
		end if;
	end process;
end BH;
--end package aludec_pkg;

		





