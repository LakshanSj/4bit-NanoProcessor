----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 03:57:18 AM
-- Design Name: 
-- Module Name: mux2_4bit_tb - Behavioral
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

entity mux2_4bit_tb is
--  Port ( );
end mux2_4bit_tb;

architecture Behavioral of mux2_4bit_tb is

component mux2_4bit
    Port ( sel : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           Y   : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal sel : STD_LOGIC := '0';
signal A   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal B   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal Y   : STD_LOGIC_VECTOR(3 downto 0);

begin

uut: mux2_4bit
    port map (
        sel => sel,
        A   => A,
        B   => B,
        Y   => Y
    );

stim_proc: process
begin
    sel <= '0'; A <= "1010"; B <= "0101"; wait for 10 ns;
    sel <= '1'; wait for 10 ns;
    sel <= '0'; wait for 10 ns;
    A <= "1111"; B <= "0000"; wait for 10 ns;
    sel <= '1'; wait for 10 ns;
    
   -- index No 240297 - 111 010 101 010 101 001
    
    A <= "1110"; B <= "1101"; sel <= '0'; wait for 10 ns;
    sel <= '1'; wait for 10 ns;

    A <= "1010"; B <= "0101"; sel <= '0'; wait for 10 ns;
    sel <= '1'; wait for 10 ns;

    A <= "1001"; B <= "1010"; sel <= '0'; wait for 10 ns;
    sel <= '1'; wait for 10 ns;

    A <= "1001"; B <= "0001"; sel <= '0'; wait for 10 ns;
    sel <= '1'; wait for 10 ns;
    
    wait;
end process;

end Behavioral;

