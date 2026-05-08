----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 08:45:20 AM
-- Design Name: 
-- Module Name: MUX2_3bit_tb - Behavioral
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

entity MUX2_3bit_tb is
--  Port ( );
end MUX2_3bit_tb;

architecture Behavioral of MUX2_3bit_tb is

component MUX2_3bit
    Port ( sel : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (2 downto 0);
           B   : in  STD_LOGIC_VECTOR (2 downto 0);
           Y   : out STD_LOGIC_VECTOR (2 downto 0));
end component;
signal sel : STD_LOGIC := '0';
signal A   : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal B   : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal Y   : STD_LOGIC_VECTOR(2 downto 0);

begin
uut: MUX2_3bit
    port map (
        sel => sel,
        A   => A,
        B   => B,
        Y   => Y
    );

stim_proc: process
begin
    sel <= '0'; A <= "101"; B <= "010"; wait for 10 ns;
    sel <= '0'; A <= "001"; B <= "110"; wait for 10 ns;
    sel <= '1'; A <= "101"; B <= "010"; wait for 10 ns;
    sel <= '1'; A <= "000"; B <= "111"; wait for 10 ns;
    sel <= '0'; A <= "011"; B <= "011"; wait for 10 ns;
    sel <= '1'; A <= "011"; B <= "011"; wait for 10 ns;
    
    -- index No 240297 - 111 010 101 010 101 001

    sel <= '0'; A <= "111"; B <= "010"; wait for 10 ns; -- 240288 pattern
    sel <= '1'; A <= "101"; B <= "010"; wait for 10 ns; -- 240294 pattern
    sel <= '0'; A <= "101"; B <= "001"; wait for 10 ns; -- 240297 pattern
    

    -- additional mixed stress cases
    sel <= '0'; A <= "011"; B <= "100"; wait for 10 ns;
    sel <= '1'; A <= "001"; B <= "110"; wait for 10 ns;
    wait; 
end process;

end Behavioral;

