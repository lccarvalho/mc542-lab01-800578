---------------------------------------------------
-- MC542 - Unicamp, 2o. semestre 2011
-- RA800578 - Luiz Claudio Carvalho
-- Atividade prática individual 01, 09/2011
-- TEST BENCH do banco de registradores
---------------------------------------------------



---------------------------------------------------
-- O CODIGO ABAIXO É DO CONTADOR DE MOEDAS!!!!
---------------------------------------------------
library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_contador is

end tb_contador;


architecture behavior of tb_contador is

  constant clk_period : time := 100 ns;  -- Clock period

  file InFile  : text open read_mode is "contador.input";    -- Input file
  file OutFile : text open write_mode is "contador.output";  -- Output file

  signal end_of_file : boolean;  	-- End of File indicator

  signal iclk : std_logic := '0';  	-- clock automatico
  signal aclk : std_logic;  		-- clock do arquivo
  signal sclk : std_logic;  		-- seletor do clock (0 => iclk, 1 => aclk)

  signal clk    : std_logic;  		-- Clock signal
  signal resetn : std_logic;
  signal sensor : std_logic_vector(0 to 4);
  signal total  : natural;

  component contador
    generic (
      nciclos :     positive := 7);
    port (
      clk     : in  std_logic;
      resetn  : in  std_logic;
      sensor  : in  std_logic_vector(0 to 4);
      total   : out natural);
  end component;


begin  -- behavior

  iclk <= not iclk after clk_period / 2;

  clk <= iclk when sclk = '0' else aclk;

  contador0 : contador
    port map (
      clk    => clk,
      resetn => resetn,
      sensor => sensor,
      total  => total);

  ReadInput : process

    variable input_line   : line;  	-- linha de entrada do arquivo
    variable command      : character;  -- comando lido do arquivo
    variable clk_value    : std_logic;
    variable resetn_value : std_logic;
    variable sensor_value : std_logic_vector(0 to 4);
    variable cicles       : natural;  	-- numero de ciclos para reter o sinal
    variable coin         : natural;

    variable output_line : line;

  begin  -- process ReadInput
    end_of_file <= false;
    resetn      <= '0';
    sensor      <= (others => '0');
    sclk        <= '0';
    wait for 7 * clk_period;  		-- aguarda a entrada estabilizar

    resetn <= '1';

    while (not EndFile(InFile)) loop
      ReadLine(InFile, input_line);

      Read(input_line, command);

      case command is
        when 'r' =>
          resetn <= '0' after clk_period / 10;
          sclk   <= '0';
          wait for clk_period * 8;
          resetn <= '1';

        when 's' =>
          Read(input_line, cicles);
          Read(input_line, sensor_value);

          sclk   <= '0';
          sensor <= sensor_value after clk_period / 10;
          wait for cicles * clk_period;

        when 'c' =>
          sclk <= '0';
          Read(input_line, cicles);
          Read(input_line, coin);

          sensor <= "10000" after clk_period / 10;
          wait for cicles * clk_period;

          if (coin > 1) then
            sensor <= "11000" after clk_period / 10;
            wait for cicles * clk_period;

            if (coin > 5) then
              sensor <= "11100" after clk_period / 10;
              wait for cicles * clk_period;

              if (coin > 10) then
                sensor <= "11110" after clk_period / 10;
                wait for cicles * clk_period;

                if (coin > 50) then
                  sensor <= "11111" after clk_period / 10;
                  wait for cicles * clk_period;

                  sensor <= "11110" after clk_period / 10;
                  wait for cicles * clk_period;
                end if;

                sensor <= "11100" after clk_period / 10;
                wait for cicles * clk_period;
              end if;

              sensor <= "11000" after clk_period / 10;
              wait for cicles * clk_period;
            end if;

            sensor <= "10000" after clk_period / 10;
            wait for cicles * clk_period;
          end if;

          sensor <= "00000" after clk_period / 10;
          wait for cicles * clk_period;

        when others => end_of_file <= true;
      end case;
    end loop;

    end_of_file <= true;
    wait for clk_period;

  end process ReadInput;


  WriteOutput : process

    variable output_line : line;
    variable command     : character;  	-- Input command

  begin  -- process WriteOutput
    Write(output_line, now, left, 12);
    Write(output_line, resetn, left, 2);
    Write(output_line, sensor, left, 6);
    Write(output_line, total, left, 4);
    WriteLine(OutFile, output_line);
    wait for clk_period;
  end process WriteOutput;

  assert not end_of_file report "End of Simulation. Exiting with Failure." severity failure;

end behavior;
