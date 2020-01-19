----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:37:43
-- Design Name: 
-- Module Name: MQ - Behavioral
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

entity maquina_estados is
    GENERIC(N:integer:=5);--tamaño de la clave
    Port ( reset : in STD_LOGIC;--SEñal de reset activa a nivel alto
           clk, mode, start : in STD_LOGIC; --mode: Seleccionar modo pulsadores (0) o switches (1) 
           --start: Pasar del estado de reposo al de selección de modos. Sirve para mostrar cuando se va a introducir la combinación.
           --finish: Para mostrar cuando se ha terminado de introducir la combinación.
           x,y : in STD_LOGIC_VECTOR (0 to N-1);--x: Entrada Pulsadores ------ y: Entrada Switches
           count_puls, count_switches: in INTEGER RANGE 0 TO N;
           led:out STD_LOGIC_VECTOR(0 TO 11));-- Salida a dos leds. led[0] es el led que indica si la combinación es correcta y 
           --led[1] indica si la combinación es incorrecta.
end maquina_estados;

--Opcion: Incluir otro led de incorrecto. (Salida)

architecture Behavioral of maquina_estados is

TYPE state_type IS (reposo, mode_sel, incorrecto, --Estados comunes
first_ok, second_ok, third_ok, fourth_ok, fifth_ok, --Estados pulsadores
first_switch_ok, second_switch_ok, third_switch_ok, fourth_switch_ok, fifth_switch_ok); --Estados switches

--NOTA: INICIALIZAR SEÑALES A SU VALOR HABITUAL PARA EVITAR FALLOS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SIGNAL state, next_state: state_type;--Estado actual y próximo estado.
--SIGNAL count_puls_ok, count_switches_ok: STD_LOGIC;--Para validar el paso a fifth_ok y fifth_switch_ok respectivamente. Señales intermedias
--SIGNAL reset_enc: std_logic;
begin

--WITH count_puls SELECT--Se actualiza a 1 el valor de count_puls_ok si count_puls es igual a 5, sino count_puls_ok='0'.
--    count_puls_ok <= '1' WHEN 5,
--    '0' WHEN OTHERS;

--WITH count_switches SELECT--Se actualiza a 1 el valor de count_switches_ok si count_switches es igual a 5, sino count_switches_ok='0'.
--    count_switches_ok <= '1' WHEN 5,
--    '0' WHEN OTHERS;

--ENC_RESET: PROCESS (clk, reset)
--BEGIN
--    IF (reset = '0') THEN
--        reset_enc <= '0';
--    ELSIF (reset = '1' AND reset'event) THEN
--        reset_enc <= '1';
--    END IF;
--END PROCESS;

SYNC_PROC: PROCESS (clk)--PROCESS encargado de actualizar el estado actual.
BEGIN
    IF rising_edge(clk) THEN
        IF (reset = '0') THEN
            state <= reposo;--Cuando reset=0, se vuelve al reposo.
        ELSE
            state <= next_state;--Cuando reset=1, se actualiza el estado.
        END IF;
    END IF;
END PROCESS;

--COUNTER_SYNC: PROCESS (count_puls, count_switches)-- Es mejor opción hacerlo dataflow (arriba está hecho así).
--BEGIN 
--    IF (count_puls=5) THEN
--        count_puls_ok <= '1';
--    ELSE
--        count_puls_ok <= '0';
--    END IF;
--    IF (count_switches=5) THEN
--            count_switches_ok <= '1';
--        ELSE
--            count_switches_ok <= '0';
--        END IF;
--END PROCESS;

OUTPUT_DECODE: PROCESS (state)--PROCESS encargado de actualizar la salida en función del estado.
BEGIN
    CASE (state) is
        WHEN reposo => led <= "001000000000";
        WHEN mode_sel => led<= "000100000000";
        WHEN incorrecto => led<="010000000000";
        --WHEN correcto => led<="10";
        --Salidas para estados pulsadores
        WHEN first_ok => led<= "000010000000";
        WHEN second_ok => led<= "000001000000";
        WHEN third_ok => led<=  "000000100000";
        WHEN fourth_ok => led<= "000000010000";
        WHEN fifth_ok => led<= "100000000000";
        --Salidas para estados switches
        WHEN first_switch_ok => led<= "000000001000";
        WHEN second_switch_ok => led<= "000000000100";
        WHEN third_switch_ok => led<= "000000000010";
        WHEN fourth_switch_ok => led<= "000000000001";
        WHEN fifth_switch_ok => led<= "100000000000";
        WHEN OTHERS => led <= "000000000000";
    END CASE;
END PROCESS;

NEXT_STATE_DECODE: PROCESS (state, x, y, start, mode, count_switches, count_puls, clk, reset)
--VARIABLE p1, p2, p3, p4, p5, sw1, sw2, sw3, sw4, sw5: STD_LOGIC_VECTOR (0 to N-1);
BEGIN
   --next_state <= reposo;
    CASE (state) is
        WHEN reposo =>
            IF (start='1') THEN
                next_state <= mode_sel;
            ELSE 
                next_state <= reposo;
            END IF;
        WHEN mode_sel =>
            IF (mode = '0') THEN
                IF (x(0)='1') THEN
                --p1:=x;
                    next_state <= first_ok;
                ELSIF (x(1)='1' OR x(2)='1' OR x(3)='1' OR x(4)='1') THEN  --x(0)='0' y se ha pulsado otro botón
                    next_state <= incorrecto;
                ELSE
                    next_state <= mode_sel;
                END IF;
            END IF;
--            IF (reset='0') THEN
--                next_state <= reposo;
--            END IF;
            IF (mode = '1') THEN 
                --sw1:=y;
                IF (y(0)='1') THEN
                    next_state <= first_switch_ok;
                ELSIF (y(1)='1' OR y(2)='1' OR y(3)='1' OR y(4)='1') THEN --y(0)='0'
                    next_state <= incorrecto;
                ELSE 
                    next_state <= mode_sel;
                END IF;
            END IF;
        WHEN incorrecto=>
            IF(reset='0') THEN
                next_state <= reposo;
            ELSE
                next_state <= incorrecto;
            END IF;
       -- Modo pulsadores:
        WHEN first_ok =>
            IF (x(1)='1') THEN --x(1)='1'
                --p2:=x;
                next_state <= second_ok;
            ELSIF (x(0)='1' OR x(2)='1' OR x(3)='1' OR x(4)='1') THEN --x(1)='0'
            --Si x no es igual a la 01000 y reset =0
                next_state <= incorrecto;--Se pasa a incorrecto
            ELSE 
                next_state <= first_ok;
            END IF;
--            IF (reset='0') THEN
--                next_state <= reposo;
--            END IF;
        WHEN second_ok =>
            IF (x(2)='1') THEN --x(2)='1'
                --p3:=x;
                next_state <= third_ok;
            ELSIF (x(0)='1' OR x(1)='1' OR x(3)='1' OR x(4)='1') THEN --x(1)='0
            --
                next_state <= incorrecto;--Se pasa a incorrecto
            ELSE
                next_state <= second_ok;
            END IF;
            
        WHEN third_ok =>
            IF (x(3)='1') THEN --x(3)='1'
                --p4:=x;
                next_state <= fourth_ok;
            ELSIF (x(0)='1' OR x(1)='1' OR x(2)='1' OR x(4)='1') THEN --x(1)='0'
                           --Si x no es igual a la 01000 y reset =0
                next_state <= incorrecto;--Se pasa a incorrecto   
            ELSE
                next_state <= third_ok;    
            END IF;
--            IF (reset='0') THEN
--                 next_state <= reposo;
--            END IF;
        WHEN fourth_ok =>
            --IF (count_puls=5) THEN --contador de los pulsadores ha llegado a 5.
--                p5:=x;
                IF (x(4)='1' AND count_puls=5) THEN
                    next_state <= fifth_ok;
                ELSIF ((x(0)='1' OR x(1)='1' OR x(2)='1' OR x(3)='1') AND count_puls=5) THEN --x(1)='0'
                               --Si x no es igual a la 01000 y reset =0
                    next_state <= incorrecto;--Se pasa a incorrecto
                ELSIF(x(0)='0' AND x(1)='0' AND x(2)='0' AND x(3)='0' AND x(4)='0') THEN
                    next_state <= fourth_ok;
                END IF;
--            IF (reset='0') THEN
--                next_state <= reposo;
--            END IF;
        WHEN fifth_ok =>--Se pone para que no haya una transición instantánea de estado a reposo y que solo se pase a dicho estado cuando reset='1'
            IF (reset='0') THEN
                next_state <= reposo;
            ELSE
                next_state <= fifth_ok;
            END IF;
        --Modo Switches:
        WHEN first_switch_ok =>
            IF (y(0)='1' AND y(1)='1') THEN --y(1)='1'
                --sw2:=y;
                next_state <= second_switch_ok;
            ELSIF (y(0)='1' AND (y(2)='1' OR y(3)='1' OR y(4)='1')) THEN--y(1)='0'
                next_state <= incorrecto;
            ELSE 
                next_state <= first_switch_ok;
            END IF;
--            IF (reset='0') THEN
--                  next_state <= reposo;
--            END IF;
        WHEN second_switch_ok =>
            IF (y(0)='1' AND y(1)='1' AND y(2)='1') THEN --y(2)='1'
                --sw3:=y;
                next_state <= third_switch_ok;
            ELSIF(y(0)='1' AND y(1)='1' AND (y(3)='1' OR y(4)='1')) THEN  --y(2)='0'
                next_state <= incorrecto;
            ELSE
                next_state <= second_switch_ok;
            END IF;
--            IF (reset='0') THEN
--                next_state <= reposo;
--            END IF;
        WHEN third_switch_ok =>
            IF (y(0)='1' AND y(1)='1' AND y(2)='1' AND y(3)='1') THEN --y(3)='1'
                --sw4:=y;
                next_state <= fourth_switch_ok;
            ELSIF(y(0)='1' AND y(1)='1' AND y(2)='1' AND y(4)='1') THEN --y(3)='1'
                next_state <= incorrecto;           
            ELSE 
                next_state <= third_switch_ok;
            END IF;
--            IF (reset='0') THEN
--                  next_state <= reposo;
--            END IF;
        WHEN fourth_switch_ok =>
            --IF (count_switches=5) THEN --y(4)='1' y count_switches_ok='1' (es decir, el contador de los switches ha llegado a 5).
                --sw5:=y;
                IF (y(0)='1' AND y(1)='1' AND y(2)='1' AND y(3)='1' AND y(4)='1' AND count_switches=5) THEN
                    next_state <= fifth_switch_ok;
                ELSIF (y(0)='1' AND y(1)='1' AND y(2)='1' AND y(3)='1' AND y(4)='0') THEN
                    next_state <= fourth_switch_ok;
                ELSE
                    next_state <= incorrecto;
                END IF;
            --END IF;
--            IF (reset='0') THEN
--                next_state <= reposo;
--            END IF;
        WHEN fifth_switch_ok =>--Se pone para que no haya una transición instantánea de estado a reposo y que solo se pase a dicho estado cuando reset='1'
            IF (reset='0') THEN
                next_state <= reposo;
            ELSE
                next_state <= fifth_switch_ok;
            END IF;
        WHEN OTHERS => next_state<=reposo;
END CASE;
END PROCESS;

end Behavioral;
