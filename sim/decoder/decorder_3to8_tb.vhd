----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 02:07:29 AM
-- Design Name: 
-- Module Name: decorder_3to8_tb - Behavioral
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

entity decorder_3to8_tb is
--  Port ( );
end decorder_3to8_tb;

architecture Behavioral of decorder_3to8_tb is

component decorder_3to8
    Port ( sel : in  STD_LOGIC_VECTOR (2 downto 0);
           en  : in  STD_LOGIC;
           Y   : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal sel : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal en  : STD_LOGIC := '0';
signal Y   : STD_LOGIC_VECTOR(7 downto 0);

begin

uut: decorder_3to8
    port map (
        sel => sel,
        en  => en,
        Y   => Y
    );

stim_proc: process
begin
    en  <= '0';
    sel <= "000"; wait for 10 ns;
    sel <= "101"; wait for 10 ns;

    en  <= '1';
    sel <= "000"; wait for 10 ns;
    sel <= "001"; wait for 10 ns;
    sel <= "010"; wait for 10 ns;
    sel <= "011"; wait for 10 ns;
    sel <= "100"; wait for 10 ns;
    sel <= "101"; wait for 10 ns;
    sel <= "110"; wait for 10 ns;
    sel <= "111"; wait for 10 ns;

    en  <= '0';
    sel <= "111"; wait for 10 ns;

    wait;
end process;

end Behavioral;
