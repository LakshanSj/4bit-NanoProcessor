----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 09:28:34 AM
-- Design Name: 
-- Module Name: pc_register - Behavioral
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

entity pc_register is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (2 downto 0);
           Q : out STD_LOGIC_VECTOR (2 downto 0));
end pc_register;

architecture Behavioral of pc_register is
signal reg : std_logic_vector(2 downto 0);

begin

process(clk, reset)
begin
    if reset = '1' then
        reg <= "000";
    elsif rising_edge(clk) then
        reg <= D;
    end if;
end process;
Q <= reg;

end Behavioral;
