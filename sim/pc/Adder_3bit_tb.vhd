----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 10:31:04 PM
-- Design Name: 
-- Module Name: Adder_3bit_tb - Behavioral
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

entity Adder_3bit_tb is
--  Port ( );
end Adder_3bit_tb;

architecture Behavioral of Adder_3bit_tb is

component Adder_3bit
    Port ( A : in  STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_VECTOR (2 downto 0));
end component;
signal A : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal Y : STD_LOGIC_VECTOR(2 downto 0);

begin
UUT: Adder_3bit port map (A => A, Y => Y);

stim_proc: process
begin
    A <= "000"; wait for 10ns;
    A <= "001"; wait for 10ns;
    A <= "010"; wait for 10ns;
    A <= "011"; wait for 10ns;
    A <= "100"; wait for 10ns;
    A <= "101"; wait for 10ns;
    A <= "110"; wait for 10ns;
    A <= "111"; wait for 10ns;  
    wait;
end process;

end Behavioral;
