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
           data : out STD_LOGIC_VECTOR (13 downto 0));
end program_rom;

architecture Behavioral of program_rom is

type rom_array is array (0 to 7) of std_logic_vector(13 downto 0);

    constant ROM : rom_array := (
        0 => "10001110000101", 
        1 => "10000010000110",   
        2 => "00001110010000",  
        3 => "10000010000101",  
        4 => "00001110010000",
        5 => "00111110010000",
        6 => "00101110010000",
        7 => "10100000000000",
        others => (others => '0')

    );
begin
    data <= ROM(to_integer(unsigned(addr)));


end Behavioral;
