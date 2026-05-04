----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 02:37:15 AM
-- Design Name: 
-- Module Name: mux8_4bit - Behavioral
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

entity mux8_4bit is
    port(
        sel : in std_logic_vector(2 downto 0);
        I0, I1, I2, I3, I4, I5, I6, I7 : in std_logic_vector(3 downto 0);
        Y : out std_logic_vector(3 downto 0)
    );
end mux8_4bit;

architecture Behavioral of mux8_4bit is

begin
    process(sel, I0, I1, I2, I3, I4, I5, I6, I7)
    begin
        case sel is
            when "000" => Y <= I0;
            when "001" => Y <= I1;
            when "010" => Y <= I2;
            when "011" => Y <= I3;
            when "100" => Y <= I4;
            when "101" => Y <= I5;
            when "110" => Y <= I6;
            when "111" => Y <= I7;
            when others => Y <= (others => '0');
        end case;
    end process;

end Behavioral;
