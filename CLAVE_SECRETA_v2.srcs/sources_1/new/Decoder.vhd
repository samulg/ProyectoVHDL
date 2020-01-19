----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:15:11
-- Design Name: 
-- Module Name: Decoder - Behavioral
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

entity Decoder is
    Port ( code: in STD_LOGIC_VECTOR(0 TO 3);--1ªcomponente: led (salida correcta maquina estados 2ªcomponente: salida led incorrecto maquina estados
           led : out STD_LOGIC_VECTOR (6 DOWNTO 0));
end Decoder;

architecture Dataflow of Decoder is
begin
WITH code SELECT
    led <= "0001000" WHEN "0000",--R
           "1111001" WHEN "0001",--I
           "0100000" WHEN "0010",--G
           "1001000" WHEN "0011",--H
           "0111001" WHEN "0100",--T
           "0110000" WHEN "0101",--E
           "0001000" WHEN "0110",--R
           "0001000" WHEN "0111",--R
           "0000001" WHEN "1000",--O
           "0001000" WHEN "1001",--R
    "1111111" WHEN OTHERS;--nada

end Dataflow;