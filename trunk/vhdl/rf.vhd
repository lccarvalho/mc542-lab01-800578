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
use std.textio.all;

entity RF is
    generic(W : natural = 32);
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

architecture rf_arch of RF is

    --type declarations
	
	--component declarations
	component reg
        generic(
            n: natural :=2
        );
        port(
		    I     : in  std_logic_vector(n-1 downto 0);
	        clock : in  std_logic;
	        load  : in  std_logic;
	        clear : in  std_logic;
	        Q     : out std_logic_vector(n-1 downto 0)
        );
	end component;
	
	--signal declarations
	
begin
	


end rf_arch;


---------------------------------------------------
-- O CODIGO ABAIXO É DO REGISTER FILE DO DP32!!!!
---------------------------------------------------

use work.dp32_types.all;
entity reg_file_32_rrw is
	generic (	depth : positive; -- number of address bits
				Tpd : Time := unit_delay;
				Tac : Time := unit_delay
	);
	port (	a1 : in bit_vector(depth-1 downto 0);
			q1 : out bus_bit_32 bus;
			en1 : in bit;
			a2 : in bit_vector(depth-1 downto 0);
			q2 : out bus_bit_32 bus;
			en2 : in bit;
			a3 : in bit_vector(depth-1 downto 0);
			d3 : in bit_32;
			en3 : in bit
	);
end reg_file_32_rrw;

architecture behaviour of reg_file_32_rrw is
begin
	reg_file: process (a1, en1, a2, en2, a3, d3, en3)
		subtype reg_addr is natural range 0 to depth-1;
		type register_array is array (reg_addr) of bit_32;
		variable registers : register_array;
	begin
		if en3 = '1' then
			registers(bits_to_natural(a3)) := d3;
		end if;
		if en1 = '1' then
			q1 <= registers(bits_to_natural(a1)) after Tac;
		else
			q1 <= null after Tpd;
		end if;
		if en2 = '1' then
			q2 <= registers(bits_to_natural(a2)) after Tac;
		else
			q2 <= null after Tpd;
		end if;
	end process reg_file;
end behaviour;