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
         Clk_100MHz : in  std_logic;
         reset      : in  std_logic;
         result     : out std_logic_vector(3 downto 0);
         zero       : out std_logic;
         overflow      : out std_logic
     );
 end component;
 
 signal clk   : std_logic := '0';
 signal reset : std_logic := '1';
 signal result : std_logic_vector(3 downto 0);
 signal zero   : std_logic;
 signal overflow  : std_logic;


begin
uut: Nanoprocessor
        port map (
            Clk_100MHz => clk,
            reset      => reset,
            result     => result,
            zero       => zero,
            overflow      => overflow
        );

    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 5ns;
            clk <= '1'; wait for 5ns;
        end loop;
    end process;

    stim_proc: process
    begin
        reset <= '1';
        wait for 20 ns;      -- hold reset for 2 clock cycles
        reset <= '0';
        wait for 400 us;     -- run program
        report "Simulation finished" severity note;
        wait;
    end process;

end Behavioral;
