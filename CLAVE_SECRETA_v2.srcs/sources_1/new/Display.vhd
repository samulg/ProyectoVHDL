----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:13:27
-- Design Name: 
-- Module Name: Display - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display is
    Port ( 
           r_or_e: in STD_LOGIC_VECTOR (1 downto 0):= "00";--Variable que determina si es error o right
           clk: in STD_LOGIC := '0';
           segment : out STD_LOGIC_VECTOR (6 downto 0) := "1111111";
           digsel : out STD_LOGIC_VECTOR (7 downto 0) := "11111111";--El digsel(4) va al primero de la siguiente fila
           led_OK: out STD_LOGIC;
           led_NOK: out STD_LOGIC
           );--El digsel(4) va al primero de la siguiente fila
           
end Display;

architecture Behavioral of Display is

component Decoder is
    Port ( code: in STD_LOGIC_VECTOR(0 TO 3);--1ªcomponente: led (salida correcta maquina estados 2ªcomponente: salida led incorrecto maquina estados
           led : out STD_LOGIC_VECTOR (6 DOWNTO 0));
end component;

--Divisor de frecuencia que divide por 1024, creo 
component div_frec is
    Generic (N: positive:= 500); 
    Port ( clk : in STD_LOGIC;
--           CE_N : in STD_LOGIC;
           clk_div : out STD_LOGIC);
end component;

Constant mux_time: time := 20 ns;--Periodo para cambiar de display de modo que el ojo no lo perciba 
signal code : STD_LOGIC_VECTOR (3 downto 0);--señal que gestiona la letra que se ha de mostrar en cada instante en los displays
--Decoder signal
signal segment_aux: STD_LOGIC_VECTOR (6 downto 0);
signal digctrl : STD_LOGIC_VECTOR (4 downto 0); -- encargada de decidir qué display se enciende en cada instante
signal clk_div: STD_LOGIC; -- reloj con frecuencia menor a la del clk

TYPE secuence is record
    code : std_logic_vector(3 DOWNTO 0);
    led : std_logic_vector(6 DOWNTO 0);
END RECORD;
--Vector de datos secuence
TYPE secuence_vector IS ARRAY (natural RANGE <>) OF secuence;
--Vector de seucuence que contiene las letras de RIGHT
Constant right: secuence_vector := (
    ("0000", "0001000"),--R
    ("0001", "1111001"),--I
    ("0010", "0100000"),--G
    ("0011", "1001000"),--H
    ("0100", "0111001") --T  
);
--Vector de seucuence que contiene las letras de ERROR
Constant error: secuence_vector := (
    ("0101", "0110000"),--E
    ("0110", "0001000"),--R
    ("0111", "0001000"),--R
    ("1000", "0000001"),--O
    ("1001", "0001000") --R      
);

begin
led_OK <= r_or_e(1);
led_NOK <= r_or_e(0);
--Decoder Instance
Decod: Decoder 
    port map 
    (
        code => code,
        led => segment_aux
    );
-- Divisor de frecuencia Instance
Div_freq: div_frec
    generic map ( N => 50000)
    port map 
    (
        clk => clk,
--        CE_N => '0', --Por el momento no se muy bien qué hacer con esto
        clk_div => clk_div
    );
        
--Display secuence

display: process (clk_div)
    variable i: positive := 1;-- Variable que 
    begin
        digctrl <= (others => '1'); -- apaga todos los displays
        if(rising_edge(clk_div)) then
            digctrl(i-1) <= '0';
             if r_or_e = "10" then -- rigth
                code <= right(i-1).code; -- lee la letra que debe representar
             elsif r_or_e = "01" then -- wrong
                code <= error(i-1).code; -- lee la letra que debe representar 
             else 
                code <= (others => '1'); -- en caso de que no sea ninguna debe apagarla
             end if;   
             if i >= 5 then
                i := 1;
             else 
                i := i + 1; -- se mueve al siguiente
             end if;
        end if;
end process;
digsel <= digctrl & "111"; -- se conecta la salida a el led que le corresponde
segment <= segment_aux;
--aux <= r_or_e;
end Behavioral;
