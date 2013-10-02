library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;


entity maindec is
	port(
		Op: in std_logic_vector(5 downto 0);
		MemToReg:	out std_logic;
		MemWrite:	out std_logic;
		Branch:		out std_logic;
		AluSrc:		out std_logic;
		RegDst:		out std_logic;
		RegWrite:	out std_logic;
		Jump:		out std_logic;
		AluOp:		out std_logic_vector(1 downto 0)
	);
end entity;

architecture BH of maindec is
	type table_rec is record
		RegWriteT:	std_logic;
		RegDstT:	std_logic;
		AluSrcT:	std_logic;
		BranchT:	std_logic;
		MemWriteT:	std_logic;
		MemToRegT:	std_logic;
		JumpT:		std_logic;
		AluOpT:		std_logic_vector(1 downto 0);
	end record;
	

type table is array (natural range <>) of table_rec;
constant tabs : table := (('1','1','0','0','0','0','0',"10"),
								('1','0','1','0','0','1','0',"00"),
								('0','0','1','0','1','0','0',"00"),
								('0','0','0','1','0','0','0',"01"),
								('1','0','1','0','0','0','0',"00"),
								('0','0','0','0','0','0','1',"00"));
--------------------------------------------------------------------
function get_index	(OpVal:in std_logic_vector(5 downto 0))
return integer is
begin
	case OpVal is
		when "000000" => return 0;
		when "100011" => return 1;
		when "101011" => return 2;
		when "000100" => return 3;
		when "001000" => return 4;
		when "000010" => return 5;
		when others   => return 6;
	end case;
end get_index;
--------------------------------------------------------------------
	
begin
	process (Op)
	variable index : integer;
	begin
		index := get_index(Op);
		if (index < 6) then
			MemToReg <= tabs(index).MemToRegT;
			MemWrite <= tabs(index).MemWriteT;
			Branch <= tabs(index).BranchT;
			AluSrc <= tabs(index).AluSrcT;
			RegDst <= tabs(index).RegDstT;
			RegWrite <= tabs(index).RegWriteT;
			Jump <= tabs(index).JumpT;
			AluOp <= tabs(index).AluOpT;
		end if;
	end process;
end BH;

