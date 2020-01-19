----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2019 12:22:47
-- Design Name: 
-- Module Name: Clave_secret_v2 - Behavioral
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

entity Clave_secret_v2 is
    GENERIC(N:INTEGER:=5);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           mode : in STD_LOGIC;
           start : in STD_LOGIC;
           pulsador : in STD_LOGIC_VECTOR (0 to N-1);
           switch : in STD_LOGIC_VECTOR (0 to N-1);
           led_OK : out STD_LOGIC;
           led_NOK : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (0 to 9);
           segment : out STD_LOGIC_VECTOR (6 downto 0);
           digsel : out STD_LOGIC_VECTOR (7 downto 0)); --El digsel(4) va al primero de la siguiente fila
end Clave_secret_v2;

architecture Behavioral of Clave_secret_v2 is

--Señales intermedias para sincronizar las entradas:
SIGNAL pulsador_sync, switch_sync: STD_LOGIC_VECTOR(0 TO N-1);
SIGNAL reset_sync, mode_sync, start_sync: STD_LOGIC;

-- Señales intermedias Debouncer:
SIGNAL x: STD_LOGIC_VECTOR(0 TO N-1);

--Señales intermedias Display:
SIGNAL code_led: STD_LOGIC_VECTOR (0 TO 1); 

-- Señales intermedias counter:
SIGNAL count_pulsador, count_switch: INTEGER RANGE 0 TO 5;

    component sync is
        Port ( sync_in : in STD_LOGIC;
               clk : in STD_LOGIC;
               sync_out : out STD_LOGIC);
    end component;
    
    component Debouncer is
        Port ( clk : in STD_LOGIC;--entrada de reloj que sincroniza al sistema
               rst : in STD_LOGIC;--entrada de reset necesaria en caso de que se desee resetear al debouncer 
               btn_in : in STD_LOGIC;--es la entrada del botón sincronizada
               btn_out : out STD_LOGIC);--es la salida con el valor definitivo una vez filtrados los rebotes
    end component;
    
    
    component Counter is
        Port(reset, mode : in STD_LOGIC;
            vector: in STD_LOGIC_VECTOR (0 TO N-1);--Vector entrada. (Hay dos instancias: Una para pulsadores (vector=x) y otra para switches (vector=y)).
            count: out INTEGER range 0 TO N);--Valor de la cuenta entero.
    end component;

    
    component Maquina_estados is
        GENERIC(N:integer:=5);--tamaño de la clave
            Port ( reset : in STD_LOGIC;--SEñal de reset activa a nivel alto
                   clk, mode, start : in STD_LOGIC; --mode: Seleccionar modo pulsadores (0) o switches (1) 
                   --start: Pasar del estado de reposo al de selección de modos. Sirve para mostrar cuando se va a introducir la combinación.
                   --finish: Para mostrar cuando se ha terminado de introducir la combinación.
                   x,y : in STD_LOGIC_VECTOR (0 to N-1);--x: Entrada Pulsadores ------ y: Entrada Switches
                   count_puls, count_switches: in INTEGER RANGE 0 TO N;
                   led:out STD_LOGIC_VECTOR(0 TO 11));-- Salida a dos leds. led[0] es el led que indica si la combinación es correcta y 
                   --led[1] indica si la combinación es incorrecta.
    end component;
    
    component Display is
        Port ( 
               r_or_e: in STD_LOGIC_VECTOR (1 downto 0):= "00";--Variable que determina si es error o right
               clk: in STD_LOGIC := '0';
               segment : out STD_LOGIC_VECTOR (6 downto 0) := "1111111";
               digsel : out STD_LOGIC_VECTOR (7 downto 0) := "11111111";--El digsel(4) va al primero de la siguiente fila
               led_OK : out STD_LOGIC;
               led_NOK : out STD_LOGIC);--El digsel(4) va al primero de la siguiente fila
    end component;
    
    
    
    
begin
    --Instanciaciones sincronizadores de señales (sync):
    inst_sync_pulsador_0: sync PORT MAP (
        sync_in => pulsador(0),
        clk => clk,
        sync_out => pulsador_sync(0)
    );
    
    inst_sync_pulsador_1: sync PORT MAP (
        sync_in => pulsador(1),
        clk => clk,
        sync_out => pulsador_sync(1)
        );
    
    inst_sync_pulsador_2: sync PORT MAP (
        sync_in => pulsador(2),
        clk => clk,
        sync_out => pulsador_sync(2)
        );
    
    inst_sync_pulsador_3: sync PORT MAP (
        sync_in => pulsador(3),
        clk => clk,
        sync_out => pulsador_sync(3)
        );
    
    inst_sync_pulsador_4: sync PORT MAP (
        sync_in => pulsador(4),
        clk => clk,
        sync_out => pulsador_sync(4)
        );
    
    inst_sync_switch_0: sync PORT MAP (
        sync_in => switch(0),
        clk => clk,
        sync_out => switch_sync(0)
        );
    
    inst_sync_switch_1: sync PORT MAP (
        sync_in => switch(1),
        clk => clk,
        sync_out => switch_sync(1)
        );
                    
    inst_sync_switch_2: sync PORT MAP (
        sync_in => switch(2),
        clk => clk,
        sync_out => switch_sync(2)
        );
                    
    inst_sync_switch_3: sync PORT MAP (
        sync_in => switch(3),
        clk => clk,
        sync_out => switch_sync(3)
        );
                    
    inst_sync_switch_4: sync PORT MAP (
        sync_in => switch(4),
        clk => clk,
        sync_out => switch_sync(4)
        );    
     
    inst_sync_reset: sync PORT MAP (
        sync_in => reset,
        clk => clk,
        sync_out => reset_sync
        );    
    
    inst_sync_mode: sync PORT MAP (
        sync_in => mode,
        clk => clk,
        sync_out => mode_sync
        );   
    
    inst_sync_start: sync PORT MAP(
        sync_in => start,
        clk => clk,
        sync_out => start_sync
        );

--Instanciaciones de Debouncer (para pulsadores):
    inst_debouncer_pulsador_0: Debouncer PORT MAP(
        clk => clk,
        rst => reset_sync,
        btn_in => pulsador_sync(0),
        btn_out => x(0)
        );

    inst_debouncer_pulsador_1: Debouncer PORT MAP(
        clk => clk,
        rst => reset_sync,
        btn_in => pulsador_sync(1),
        btn_out => x(1)
        );

    inst_debouncer_pulsador_2: Debouncer PORT MAP(
        clk => clk,
        rst => reset_sync,
        btn_in => pulsador_sync(2),
        btn_out => x(2)
        );  

    inst_debouncer_pulsador_3: Debouncer PORT MAP(
        clk => clk,
        rst => reset_sync,
        btn_in => pulsador_sync(3),
        btn_out => x(3)
        );  

    inst_debouncer_pulsador_4: Debouncer PORT MAP(
        clk => clk,
        rst => reset_sync,
        btn_in => pulsador_sync(4),
        btn_out => x(4)
        );  
  
 --Instanciaciones counter: Una instancia para pulsadores (vector=x) y otra para switches (vector=y).
    counter_pulsadores:Counter PORT MAP(
        vector=>x,
        mode => mode_sync,
        reset => reset_sync,
        count => count_pulsador--,
        --clk => clk
    ); 
    
    counter_switches:Counter PORT MAP(
            vector=>switch_sync,
            mode => mode_sync,
            reset => reset_sync,
            count => count_switch--,
            --clk => clk
        ); 

--Instanciación máquina de estados:
    inst_maq_estados: maquina_estados PORT MAP(
        clk => clk,
        reset => reset_sync,
        mode => mode_sync,
        start => start_sync,
        x => x,
        y => switch_sync,
        count_switches => count_switch,
        count_puls => count_pulsador,
        led(0) => code_led(0),--led_correcto,
        led(1) => code_led(1),--led_incorrecto,
        led(2) => led(0),
        led(3) => led(1),
        led(4) => led(2),
        led(5) => led(3),
        led(6) => led(4),
        led(7) => led(5),
        led(8) => led(6),
        led(9) => led(7),
        led(10) => led(8),
        led(11) => led(9) 
     );
    
    inst_display: Display PORT MAP(
        r_or_e (0) => code_led(1),
        r_or_e (1) => code_led(0),
        clk => clk,
        segment => segment,
        digsel => digsel,
        led_OK => led_OK,
        led_NOK => led_NOK
    );
     
--Instanciación Decoder:
--    inst_Decoder: Decoder PORT MAP(
--        code => code_led,
--        led1 => display1,
--        led2 => display2,
--        led3 => display3,
--        led4 => display4,
--        led5 => display5,
--        led(0)=> led_correcto,
--        led(1)=> led_incorrecto
--    );

end Behavioral;