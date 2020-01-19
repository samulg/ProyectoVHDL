----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2019 18:05:36
-- Design Name: 
-- Module Name: Sincronizador - Behavioral
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

entity sync is
    Port ( sync_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end sync;

architecture Behavioral of sync is
    constant SYNC_STAGES : integer := 3;
    constant PIPELINE_STAGES : integer := 1;
    constant INIT : std_logic := '0';
    signal sreg : std_logic_vector(SYNC_STAGES-1 downto 0) := (others => INIT);
    attribute async_reg : string;
    attribute async_reg of sreg : signal is "true";
    signal sreg_pipe : std_logic_vector(PIPELINE_STAGES-1 downto 0) := (others => INIT);
    attribute shreg_extract : string;
    attribute shreg_extract of sreg_pipe : signal is "false";
begin
process(clk)
begin
    if(clk'event and clk='1')then
        sreg <= sreg(SYNC_STAGES-2 downto 0) & sync_in;
    end if;
end process;

no_pipeline : if PIPELINE_STAGES = 0 generate
begin
    sync_out <= sreg(SYNC_STAGES-1);
end generate;

one_pipeline : if PIPELINE_STAGES = 1 generate
begin
    process(clk)
    begin
        if(clk'event and clk='1') then
            sync_out <= sreg(SYNC_STAGES-1);
        end if;
    end process;
end generate;

multiple_pipeline : if PIPELINE_STAGES > 1 generate
begin
    process(clk)
    begin
        if(clk'event and clk='1') then
            sreg_pipe <= sreg_pipe(PIPELINE_STAGES-2 downto 0) & sreg(SYNC_STAGES-1);
        end if;
    end process;
sync_out <= sreg_pipe(PIPELINE_STAGES-1);
end generate;
end Behavioral;

