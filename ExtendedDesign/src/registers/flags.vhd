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
    clk          : in  STD_LOGIC;
    enable       : in STD_LOGIC;
    reset        : in  STD_LOGIC;
    flag_en      : in  STD_LOGIC;
    cmp_en       : in STD_LOGIC;    
    alu_zero       : in  STD_LOGIC;
    alu_overflow : in STD_LOGIC;
    alu_GT       : in STD_LOGIC;
    alu_EQ       : in STD_LOGIC;
    alu_LT       : in STD_LOGIC;
    Z            : out STD_LOGIC;
    V            : out STD_LOGIC;
    GT           : out STD_LOGIC;
    EQ           : out STD_LOGIC;
    LT           : out STD_LOGIC );
end flags;

architecture Behavioral of flags is

signal Z_reg : std_logic := '0';
signal V_reg : std_logic := '0';
signal GT_reg : std_logic := '0';
signal EQ_reg : std_logic := '0';
signal LT_reg : std_logic := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            Z_reg <= '0';
            V_reg <= '0';
            GT_reg <= '0';
            EQ_reg <= '0';
            LT_reg <= '0';
    
        elsif rising_edge(clk) then
             if enable = '1' then
               
                   if flag_en = '1' then
                       Z_reg  <= alu_zero;
                       V_reg  <= alu_overflow;
                       
                       GT_reg <= '0';
                       EQ_reg <= '0';
                       LT_reg <= '0';
       
                   elsif cmp_en = '1' then
                       GT_reg <= alu_GT;
                       EQ_reg <= alu_EQ;
                       LT_reg <= alu_LT;
                       Z_reg <= '0';
                       V_reg <= '0';
       
                   else
                       Z_reg  <= '0';
                       V_reg  <= '0';
                       GT_reg <= '0';
                       EQ_reg <= '0';
                       LT_reg <= '0';
                   end if;
       
               end if;
           end if;
    end process;

Z <= Z_reg;
V <= V_reg;
GT <= GT_reg;
EQ <= EQ_reg;
LT <= LT_reg;

end Behavioral;
