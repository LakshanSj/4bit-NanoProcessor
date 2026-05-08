----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 08:57:09 PM
-- Design Name: 
-- Module Name: FA_tb - Behavioral
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

entity FA_tb is
--  Port ( );
end FA_tb;

architecture Behavioral of FA_tb is
component HA
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           C : out STD_LOGIC;
           S : out STD_LOGIC);
end component;

component FA
    Port ( A    : in  STD_LOGIC;
           B    : in  STD_LOGIC;
           C_in : in  STD_LOGIC;
           S    : out STD_LOGIC;
           C_out: out STD_LOGIC);
end component;

signal A, B, C_in : STD_LOGIC := '0';
signal S, C_out   : STD_LOGIC;

begin

uut: FA port map (
    A     => A,
    B     => B,
    C_in  => C_in,
    S     => S,
    C_out => C_out
);

stim_proc: process
begin
 -- index no : 240288 111 010 101 010 100 000
 --          : 240294 111 010 101 010 100 110
 --          : 240297 111 010 101 010 101 001
 --          : 240312 111 010 101 010 111 000
    A <= '0'; B <= '0'; C_in <= '0'; wait for 20 ns;
    A <= '1'; B <= '1'; C_in <= '0'; wait for 20 ns;
    A <= '0'; B <= '0'; C_in <= '1'; wait for 20 ns;
    A <= '1'; B <= '1'; C_in <= '1'; wait for 20 ns;
    A <= '1'; B <= '0'; C_in <= '0'; wait for 20 ns;
    A <= '1'; B <= '0'; C_in <= '1'; wait for 20 ns;
    A <= '0'; B <= '1'; C_in <= '0'; wait for 20 ns;
    A <= '0'; B <= '1'; C_in <= '1'; wait for 20 ns; --random
    wait;
end process;
end Behavioral;

