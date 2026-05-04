----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2026 08:27:52 PM
-- Design Name: 
-- Module Name: step_button - Behavioral
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

entity step_button is
    Port (
       clk   : in  STD_LOGIC;
       btn   : in  STD_LOGIC;
       pulse : out STD_LOGIC
    );
end step_button;

architecture Behavioral of step_button is
   signal btn_prev : STD_LOGIC := '0';
begin

   process(clk)
   begin
       if rising_edge(clk) then
           pulse <= '0';

           if (btn = '1' and btn_prev = '0') then
               pulse <= '1';
           end if;

           btn_prev <= btn;
       end if;
   end process;

end Behavioral;
