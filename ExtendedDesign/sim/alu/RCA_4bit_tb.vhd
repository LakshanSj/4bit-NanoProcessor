----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 09:11:03 PM
-- Design Name: 
-- Module Name: RCA_4bit_tb - Behavioral
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

entity RCA_4bit_tb is
--  Port ( );
end RCA_4bit_tb;

architecture Behavioral of RCA_4bit_tb is
component RCA_4bit
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           C_in : in  STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           C_out : out STD_LOGIC);
end component;
signal A, B, S : STD_LOGIC_VECTOR (3 downto 0);
signal C_in, C_out : STD_LOGIC;

begin
uut: RCA_4bit port map (
        A     => A,
        B     => B,
        C_in  => C_in,
        S     => S,
        C_out => C_out
    );
--index no : 240288D - 0011 1010 1010 1010 0000 
stim_proc: process
begin
    A <= "0000"; B <= "0000"; C_in <= '0'; wait for 10 ns;
    A <= "0000"; B <= "1010"; C_in <= '0'; wait for 10 ns;
    A <= "1010"; B <= "1010"; C_in <= '0'; wait for 10 ns;
    A <= "1010"; B <= "0011"; C_in <= '0'; wait for 10 ns;
    A <= "0011"; B <= "0011"; C_in <= '0'; wait for 10 ns;
    A <= "0000"; B <= "1111"; C_in <= '0'; wait for 10 ns;
    A <= "0000"; B <= "1010"; C_in <= '1'; wait for 10 ns;
    A <= "1010"; B <= "1010"; C_in <= '1'; wait for 10 ns;
    A <= "1010"; B <= "1011"; C_in <= '1'; wait for 10 ns;
    A <= "0011"; B <= "0011"; C_in <= '1'; wait for 10 ns;
    wait;
end process;

end Behavioral;

