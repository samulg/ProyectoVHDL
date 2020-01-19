----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:16:01
-- Design Name: 
-- Module Name: Div_frecuencia - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity div_frec is
Generic (N: positive:= 500);
    Port ( clk : in STD_LOGIC;
           --CE_N : in STD_LOGIC;
           clk_div : out STD_LOGIC);
end div_frec;

architecture Behavioral of div_frec is

signal clk_div_aux: STD_LOGIC:='0';
begin
process (clk)
variable count: integer :=0;
begin
--      if (CE_N = '0') then
--        clk_div_aux <= '0';
      if (rising_edge(clk)) then
        count := count + 1;
        if(count = N) then
            clk_div_aux <= NOT clk_div_aux;
            count := 1;
        end if;
    end if;        
 end process; 
clk_div <= clk_div_aux;
end Behavioral;
