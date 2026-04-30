----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 10:46:24 AM
-- Design Name: 
-- Module Name: slow_clock_tb - Behavioral
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

entity slow_clock_tb is
--  Port ( );
end slow_clock_tb;

architecture Behavioral of slow_clock_tb is
component slow_clock
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;
signal clk_in, clk_out : std_logic;

begin
UUT : slow_clock
    port map ( clk_in => clk_in,
               clk_out => clk_out);
               
clk_process : process
begin
    while true loop
        clk_in <= '1'; wait for 10ns;
        clk_in <= '0'; wait for 10 ns;
    end loop;
end process;

end Behavioral;
