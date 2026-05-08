----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 02:41:24 AM
-- Design Name: 
-- Module Name: mux8_4bit_tb - Behavioral
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

entity mux8_4bit_tb is
--  Port ( );
end mux8_4bit_tb;

architecture Behavioral of mux8_4bit_tb is

component mux8_4bit
        port(
            sel : in std_logic_vector(2 downto 0);
            I0, I1, I2, I3, I4, I5, I6, I7 : in std_logic_vector(3 downto 0);
            Y : out std_logic_vector(3 downto 0)
        );
    end component;

    signal sel : std_logic_vector(2 downto 0) := "000";
    signal I0, I1, I2, I3, I4, I5, I6, I7 : std_logic_vector(3 downto 0);
    signal Y : std_logic_vector(3 downto 0);

begin

    uut: mux8_4bit
        port map (
            sel => sel,
            I0  => I0,
            I1  => I1,
            I2  => I2,
            I3  => I3,
            I4  => I4,
            I5  => I5,
            I6  => I6,
            I7  => I7,
            Y   => Y
        );

    stim_proc: process
    begin
        I0 <= "0001"; I1 <= "0010"; I2 <= "0011"; I3 <= "0100";
        I4 <= "0101"; I5 <= "0110"; I6 <= "0111"; I7 <= "1000";
        wait for 10 ns;

        sel <= "000"; wait for 10 ns;
        sel <= "001"; wait for 10 ns;
        sel <= "010"; wait for 10 ns;
        sel <= "011"; wait for 10 ns;
        sel <= "100"; wait for 10 ns;
        sel <= "101"; wait for 10 ns;
        sel <= "110"; wait for 10 ns;
        sel <= "111"; wait for 10 ns;
        
       -- index No 240297 - 111 010 101 010 101 001
        
        I0 <= "1110"; I1 <= "1101"; I2 <= "1010"; I3 <= "0101";
        I4 <= "1010"; I5 <= "1001"; I6 <= "1111"; I7 <= "0001";
        wait for 10 ns;

        sel <= "111"; wait for 10 ns;
        sel <= "010"; wait for 10 ns;
        sel <= "101"; wait for 10 ns;
        sel <= "001"; wait for 10 ns;

        I0 <= "1001"; I1 <= "1010"; I2 <= "0101"; I3 <= "1110";
        I4 <= "1111"; I5 <= "0001"; I6 <= "0111"; I7 <= "1101";
        wait for 10 ns;

        sel <= "000"; wait for 10 ns;
        sel <= "100"; wait for 10 ns;
        sel <= "110"; wait for 10 ns;

        wait;
    end process;
end Behavioral;

