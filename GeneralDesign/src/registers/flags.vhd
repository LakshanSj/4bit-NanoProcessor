----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2026 11:45:13 AM
-- Design Name: 
-- Module Name: flags - Behavioral
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

entity flags is
Port (
    clk      : in  STD_LOGIC;
    enable   : in STD_LOGIC;
    reset    : in  STD_LOGIC;
    flag_en       : in  STD_LOGIC;

    alu_zero : in  STD_LOGIC;
    alu_overflow : in STD_LOGIC;

    Z        : out STD_LOGIC;
    V        : out STD_LOGIC );
end flags;

architecture Behavioral of flags is

signal Z_reg : std_logic := '0';
signal V_reg : std_logic := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            Z_reg <= '0';
            V_reg <= '0';
    
        elsif rising_edge(clk) then
            if (flag_en = '1' and enable = '1') then
                Z_reg <= alu_zero;
                V_reg <= alu_overflow;
            end if;
        end if;
    end process;

Z <= Z_reg;
V <= V_reg;

end Behavioral;
