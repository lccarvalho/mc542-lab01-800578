---------------------------------------------------
-- MC542 - Unicamp, 2o. semestre 2011
-- RA800578 - Luiz Claudio Carvalho
-- Atividade pratica individual 01, 09/2011
-- Banco de registradores
---------------------------------------------------
-- Leitura assincrona de dois registradores: 
--   as saidas RD1 e RD2 correspondem sempre aos 
--   dados armazenados nos registradores cujos 
--   enderecos estao em A1 e A2.
-- Escrita sincrona de um registrador:
--   o dado escrito no registrador enderecado
--   por A3 eh o fornecido em WD3,
--   usando o sinal We3 como enable. 
-- O registrador localizado na posicao zero (0) 
--   do banco de registradores sempre tera o valor
--   zero ("00000000000000000000000000000000").
---------------------------------------------------

-- CHECAR LIBRARIES REALMENTE NECESSARIAS ************
library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity RF is
    generic(W : natural := 32);
    port(A1 :  in  std_logic_vector(4 downto 0);
         A2 :  in  std_logic_vector(4 downto 0);
         A3 :  in  std_logic_vector(4 downto 0);
         WD3 : in  std_logic_vector(W-1 downto 0);
         clk : in  std_logic;
         We3 : in  std_logic;
         RD1 : out std_logic_vector(W-1 downto 0);
         RD2 : out std_logic_vector(W-1 downto 0)
    );
end RF;

architecture behaviour of RF is
	subtype std_logic_W is std_logic_vector(W-1 downto 0);
	type register_array is array (0 to 4) of std_logic_W;
	signal registers : register_array;
begin
	-- setar o registrador R(0)	
	set_R0: process
	begin
		registers(0) <= "00000000000000000000000000000000";
		wait;
	end process set_R0;

	-- escrita sincrona
	rf: process (clk)		
	begin
		if clk'event and (clk = '1' and We3 = '1') then
			if conv_integer(A3) /= 0 then
				registers(conv_integer(A3)) <= WD3;
			end if;
			if conv_integer(A3) = conv_integer(A1) then
				RD1 <= registers(conv_integer(A1));			
			end if;
			if conv_integer(A3) = conv_integer(A2) then
				RD2 <= registers(conv_integer(A2));			
			end if;
		end if;
	end process rf;

	-- leitura assincrona de A1
	setA1: process (A1)
	begin
		RD1 <= registers(conv_integer(A1));
	end process setA1;

	-- leitura assincrona de A2
	setA2: process (A2)
	begin
		RD2 <= registers(conv_integer(A2));
	end process setA2;

end behaviour;


