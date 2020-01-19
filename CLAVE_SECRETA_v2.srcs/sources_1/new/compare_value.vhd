----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:41:57
-- Design Name: 
-- Module Name: compare_value - Behavioral
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

entity compare_value is
GENERIC(N:integer:=5);--tamaño de la clave
    Port ( reset: in STD_LOGIC;
           customize : in STD_LOGIC;
           x,y : in STD_LOGIC_VECTOR (0 to N-1);
           u,v : out STD_LOGIC_VECTOR (0 to N-1));
end compare_value;

architecture Behavioral of compare_value is

begin
PROCESS(x, y, customize, reset)
BEGIN
    --IF(reset='1') THEN
    

END PROCESS; 

end Behavioral;
