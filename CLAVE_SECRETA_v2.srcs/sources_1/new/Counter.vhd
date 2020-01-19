----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:09:23
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
    GENERIC(N:INTEGER:=5);
    Port ( reset, mode : in STD_LOGIC;
    vector: in STD_LOGIC_VECTOR (0 TO N-1);-- Vector entrada (Hay dos instancias: Una para pulsadores (vector=x) y otra para switches (vector=y).
    count: out INTEGER range 0 TO N
    );
end Counter;

architecture Behavioral of Counter is
--SIGNAL count_std: STD_LOGIC_VECTOR (0 TO 2);-- Salida en binario, que posteriormente se convertirá a unsigned (count_uns).
--SIGNAL count_uns: UNSIGNED (count_std' range);--Salida en unsigned que posteriormente se convertirá a integer (count):
begin
process(vector, reset, mode)
VARIABLE suma: INTEGER RANGE 0 TO 5:=0;--STD_LOGIC_VECTOR (0 TO 2):="000";
begin
    IF (reset='0') THEN
        suma:=0;
    ELSIF (suma<5) THEN
        IF (mode='0') THEN--Modo pulsadores 
            IF (vector = "10000" OR vector = "01000" OR vector = "00100" OR vector = "00010" OR vector = "00001")  THEN--vector distinto de 00000, para que no se incremente la suma 
        --cuando se ha dejado de pulsar un botón.
            suma := suma + 1; --Cada vez que el vector de entrada cambia, la suma se incrementa en el modo contadores,
            --ya que implica que ha habido una nueva pulsación. Ej: 10000 (pulsación 1)--> 01000 (pulsación 2).
            END IF;
        ELSE--Modo SWITCHES.    
            CASE vector IS 
            WHEN "10000" | "01000" | "00100" | "00010" | "00001" => suma:=1;
            WHEN "11000" | "10100" | "10010" | "10001" | "01100" | "01010" | "01001" | "00110" | "00101" | "00011" => suma:=2;
            WHEN "00111" | "01011" | "01101" | "01110" | "10011" | "10101" | "10110" | "11001" | "11010" | "11100" => suma:=3;
            WHEN "11110" | "01111" | "11011" | "10111" | "11101" => suma:=4;
            WHEN "11111" => suma:=5;
            WHEN OTHERS => suma:=0;
            END CASE; 
        END IF;
    END IF; 
count<=suma;   
end process;
--count_uns <= unsigned(count_std);
--count <= to_integer(count_uns);
end Behavioral;
