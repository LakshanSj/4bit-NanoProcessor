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

component decoder_3_to_8
    Port ( reg_sel : in  STD_LOGIC_VECTOR (2 downto 0);
           en  : in  STD_LOGIC;
           y   : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal reg_sel : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal en  : STD_LOGIC := '0';
signal y   : STD_LOGIC_VECTOR(7 downto 0);

begin

uut: decoder_3_to_8
    port map (
        reg_sel => reg_sel,
        en  => en,
        y   => y
    );
--index no : 240312A - 111 010 101 010 111 000
stim_proc: process
begin
    en  <= '0';
    reg_sel <= "000"; wait for 10 ns;
    reg_sel  <= "111"; wait for 10 ns;

    en  <= '1';
    reg_sel  <= "000"; wait for 10 ns;
    reg_sel  <= "111"; wait for 10 ns;
    reg_sel  <= "010"; wait for 10 ns;
    reg_sel  <= "101"; wait for 10 ns;
    
    reg_sel  <= "001"; wait for 10 ns;   --random
    reg_sel  <= "011"; wait for 10 ns;   --random
    reg_sel  <= "100"; wait for 10 ns;   --random
    reg_sel  <= "110"; wait for 10 ns;   --random

    en  <= '0';
    reg_sel  <= "010"; wait for 10 ns;

    wait;
end process;

end Behavioral;

