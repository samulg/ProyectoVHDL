----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:08:10
-- Design Name: 
-- Module Name: Debouncer - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debouncer is
    Port ( clk : in STD_LOGIC;--entrada de reloj que sincroniza al sistema
           rst : in STD_LOGIC;--entrada de reset necesaria en caso de que se desee resetear al debouncer 
           btn_in : in STD_LOGIC;--es la entrada del botón sincronizada
           btn_out : out STD_LOGIC);--es la salida con el valor definitivo una vez filtrados los rebotes
end Debouncer;

architecture Behavioral of Debouncer is
signal Q1, Q2, Q3 : std_logic;--Señales auxiliares que permiten evaluar siempre los valores anteriores de la señal
begin
process(clk)--se obliga a entrar con cada cambio de reloj
 begin
if (clk'event and clk = '1') then --ante el flanco de subida del reloj
  if (rst = '0') then --en caso de que la señeal reset esté activa a (nivel bajo)
    Q1 <= '0';-- asigna ceros en caso de que esté reseteado
    Q2 <= '0';-- asigna ceros en caso de que esté reseteado
    Q3 <= '0';-- asigna ceros en caso de que esté reseteado
  else
    Q1 <= btn_in;--le asigna a Q1 el valor actual 
    Q2 <= Q1;--le asigna a Q2 el valor de Q1 que como no ha sido actualizado es el que tuviera de la iteración anerior
    Q3 <= Q2;--le asigna a Q3 el valor de Q2 que como no ha sido actualizado es el que tuviera de la iteración anerior
  end if;
end if;
end process;
  btn_out <= Q1 and Q2 and (not Q3);--saca por la salida la lógica tal que si el actual y el anterior son uno y antes 
  --tenían un cero considera que ya se ha alcanzado el régimen permanente

end Behavioral;