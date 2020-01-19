----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2019 12:47:12
-- Design Name: 
-- Module Name: Clave_secret_v2_tb - Behavioral
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

entity Clave_secret_v2_tb is
--  Port ( );
end Clave_secret_v2_tb;

architecture Behavioral of Clave_secret_v2_tb is

component Clave_secret_v2 is
    GENERIC(N:INTEGER:=5);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           mode : in STD_LOGIC;
           start : in STD_LOGIC;
           pulsador: in STD_LOGIC_VECTOR(0 TO N-1);
           switch: in STD_LOGIC_VECTOR(0 TO N-1);
           led_OK: out STD_LOGIC;
           led_NOK: out STD_LOGIC;
           led: out STD_LOGIC_VECTOR(0 TO 9);
           segment : out STD_LOGIC_VECTOR (6 downto 0);
           digsel : out STD_LOGIC_VECTOR (7 downto 0));--El digsel(4) va al primero de la siguiente fila
end component;

CONSTANT BUS_N: INTEGER := 5;
CONSTANT k: time := 5 ns;

SIGNAL clk_in: STD_LOGIC;
SIGNAL reset_in: STD_LOGIC;
SIGNAL mode_in: STD_LOGIC;
SIGNAL start_in: STD_LOGIC;
SIGNAL pulsador_in, switch_in: STD_LOGIC_VECTOR(0 TO BUS_N-1);
SIGNAL led_OK_out: STD_LOGIC;
SIGNAL led_NOK_out: STD_LOGIC;
SIGNAL led_out: STD_LOGIC_VECTOR(0 TO 9);
SIGNAL segment_out: STD_LOGIC_VECTOR (6 downto 0);
SIGNAL digsel_out: STD_LOGIC_VECTOR (7 downto 0);

begin

    uut_1: Clave_secret_v2 PORT MAP(
        clk => clk_in,
        reset => reset_in,
        mode => mode_in,
        start => start_in,
        pulsador => pulsador_in,
        switch => switch_in,
        led_OK => led_OK_out,
        led_NOK => led_NOK_out,
        led => led_out,
        segment => segment_out,
        digsel => digsel_out);
        
    pulsador_clk: PROCESS
    begin
        clk_in <= '0';
        WAIT FOR 2*k;
        clk_in <= '1';
        WAIT FOR 2*k;
    END PROCESS;
    
    pulsador_reset: PROCESS
    begin
        reset_in <= '1';
        wait for k;
        reset_in <= '0';
        wait for 2*k;
        reset_in <= '1';
        WAIT FOR 9*k;
        reset_in <= '0';
        wait for 2*k;
        reset_in <= '1';
        wait;
    end process;
    
    pulsador_mode: PROCESS
    begin
        mode_in <= '0';
        wait for 17*k;
        mode_in <= '1';
        wait;
    end process;
        
    pulsador_start: PROCESS
    begin
        start_in <= '0';
        wait for 5*k;
        start_in <= '1';
        wait for 2*k;
        start_in <= '0';
        wait for 10*k;
        start_in <= '1';
        wait for 2*k;
        start_in <= '0';
        wait;
    end process;
    
    p_pulsador: PROCESS
    begin
        pulsador_in <=(OTHERS => '0');
        wait for 9*k;
        pulsador_in <= (0 => '1', OTHERS => '0');
        wait;
    end process;
    
    p_switch: PROCESS
    begin
        switch_in <= (OTHERS => '0');
        wait for 21*k;
        switch_in <= (0 => '1', OTHERS => '0');
        wait;
    end process;


end Behavioral;
