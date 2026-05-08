----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 04:12:25 AM
-- Design Name: 
-- Module Name: program_rom - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_rom is
    Port ( addr : in  STD_LOGIC_VECTOR (2 downto 0);
           data : out STD_LOGIC_VECTOR (11 downto 0));
end program_rom;

architecture Behavioral of program_rom is

type rom_array is array (0 to 7) of std_logic_vector(11 downto 0);

    constant ROM : rom_array := (
       0 => "101110000000",   -- MOVI R7, 0   (R7 = 0)
       1 => "100010000001",   -- MOVI R1, 1   (R1 = 1)
       2 => "001110010000",   -- ADD  R7, R1  (R7 = 0+1 = 1)
       3 => "100010000010",   -- MOVI R1, 2   (R1 = 2)
       4 => "001110010000",   -- ADD  R7, R1  (R7 = 1+2 = 3)
       5 => "100010000011",   -- MOVI R1, 3   (R1 = 3)
       6 => "001110010000",   -- ADD  R7, R1  (R7 = 3+3 = 6)
       7 => "110000000000",   -- JZR  R0, 0
        others => (others => '0')

    );
begin
    data <= ROM(to_integer(unsigned(addr)));


end Behavioral;
