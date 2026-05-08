----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 03:00:14 PM
-- Design Name: 
-- Module Name: Nanoprocessor_tb - Behavioral
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

entity Nanoprocessor_tb is
--  Port ( );
end Nanoprocessor_tb;

architecture Behavioral of Nanoprocessor_tb is
 
 component Nanoprocessor
         Port (
             Clk_100MHz : in  STD_LOGIC;
             reset      : in  std_logic;
             mode_sel   : in  STD_LOGIC;
             sw_inst    : in  STD_LOGIC_VECTOR(13 downto 0);
             btn_step   : in  STD_LOGIC;
             result     : out std_logic_vector(3 downto 0);
             zero       : out std_logic;
             overflow   : out std_logic;
             greater  : out std_logic;
             equal  : out std_logic;
             lower  : out std_logic
         );
     end component;
 
     signal Clk_100MHz : STD_LOGIC := '0';
     signal reset      : STD_LOGIC := '0';
     signal mode_sel   : STD_LOGIC := '0';
     signal sw_inst    : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');
     signal btn_step   : STD_LOGIC := '0';
     signal result     : STD_LOGIC_VECTOR(3 downto 0);
     signal zero       : STD_LOGIC;
     signal overflow   : STD_LOGIC;
     signal greater, equal, lower : STD_LOGIC;
 
     constant clk_period : time := 10 ns;
 
 begin
 
     uut: Nanoprocessor
         port map (
             Clk_100MHz => Clk_100MHz,
             reset      => reset,
             mode_sel   => mode_sel,
             sw_inst    => sw_inst,
             btn_step   => btn_step,
             result     => result,
             zero       => zero,
             overflow   => overflow,
             greater    => greater,
             equal      => equal,
             lower      => lower
         );
 
     clk_process : process
     begin
         while true loop
             Clk_100MHz <= '0';
             wait for clk_period / 2;
             Clk_100MHz <= '1';
             wait for clk_period / 2;
         end loop;
     end process;
 
     stim_proc : process
     begin
         -- Assert reset for a few cycles
         reset <= '1';
         wait for 40 ns;
         reset <= '0';
 
         -- Auto run mode (uses internal ROM)
         mode_sel <= '0';
         sw_inst  <= (others => '0');
         btn_step <= '0';
 
         -- Wait long enough for many instructions
         wait for 5000 ns;
 
         wait;   -- stop simulation
     end process;


end Behavioral;

