----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 08:47:33 PM
-- Design Name: 
-- Module Name: HA_tb - Behavioral
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

entity HA_tb is
--  Port ( );
end HA_tb;

architecture Behavioral of HA_tb is
component HA
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           C : out STD_LOGIC;
           S : out STD_LOGIC);
end component;
signal A, B : STD_LOGIC := '0';
signal C, S : STD_LOGIC;

begin

uut: HA port map (
    A => A,
    B => B,
    C => C,
    S => S
);

stim_proc: process
begin
    A <= '0'; B <= '0'; wait for 50 ns;
    A <= '0'; B <= '1'; wait for 50 ns;
    A <= '1'; B <= '0'; wait for 50 ns;
    A <= '1'; B <= '1'; wait for 50 ns;
    wait;
end process;
end Behavioral;
