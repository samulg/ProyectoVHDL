----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:43:29
-- Design Name: 
-- Module Name: enclavador - Behavioral
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

entity enclavador is
GENERIC(N:integer:=5);--tamaño de la clave
Port ( 
    clk: IN std_logic;
    reset: IN std_logic;
    x: IN STD_LOGIC_VECTOR(0 to N-1);
    x_enc: OUT STD_LOGIC_VECTOR(0 to N-1)--;
    --reset_enc: OUT std_logic
);
end enclavador;

architecture Behavioral of enclavador is

begin
process(clk, x)
BEGIN
    if (reset='0') THEN 
        x_enc <= (OTHERS=>'0');
    elsif (rising_edge(clk)) THEN
        x_enc <= x;
    END IF;
end process; 

end Behavioral;
