----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 10:41:07 AM
-- Design Name: 
-- Module Name: slow_clock - Behavioral
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

entity slow_clock is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end slow_clock;

architecture Behavioral of slow_clock is
signal count : integer := 1;
signal clk_status : std_logic :='0';

begin
    process (clk_in) begin
        if (rising_edge(clk_in)) then
            count <= count + 1;
            if(count = 25000000) then
                clk_status <= not clk_status;
                count <= 1;
            end if;
        end if;
    end process;
    clk_out <= clk_status;
end Behavioral;
