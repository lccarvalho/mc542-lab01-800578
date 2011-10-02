---------------------------------------------------
-- O CODIGO ABAIXO É DO CONTADOR DE MOEDAS!!!!
---------------------------------------------------

ghdl -a --ieee=synopsys ffd.vhd 
ghdl -a --ieee=synopsys debounce.vhd
ghdl -a --ieee=synopsys contador.vhd
ghdl -a --ieee=synopsys tb_contador_base.vhd
ghdl -a --ieee=synopsys tb_contador.vhd
ghdl -e --ieee=synopsys tb_contador_base
ghdl -e --ieee=synopsys tb_contador
