----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 08:46:15 PM
-- Design Name: 
-- Module Name: register_bank - Behavioral
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

entity register_bank is
    port(
        clk, reset, enable  : in std_logic;
        write_en    : in std_logic;
        write_sel   : in std_logic_vector(2 downto 0);
        write_data  : in std_logic_vector(3 downto 0);
        R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector (3 downto 0));
        
end register_bank;

architecture Behavioral of register_bank is

component decoder_3_to_8
    port(reg_sel : in std_logic_vector(2 downto 0);
         en  : in std_logic;
         Y   : out std_logic_vector(7 downto 0));
end component;

component register_4bit
    port(clk, reset, enable, we : in std_logic;
         D : in std_logic_vector(3 downto 0);
         Q : out std_logic_vector(3 downto 0));
end component;

signal we_lines : std_logic_vector(7 downto 0);
--signal R0,R1,R2,R3,R4,R5,R6,R7 : std_logic_vector(3 downto 0);

begin

    DEC: decoder_3_to_8
    port map(reg_sel=>write_sel, en=>write_en, Y=>we_lines);

    REG0: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(0), D=>write_data, Q=>R0);
    REG1: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(1), D=>write_data, Q=>R1);
    REG2: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(2), D=>write_data, Q=>R2);
    REG3: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(3), D=>write_data, Q=>R3);
    REG4: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(4), D=>write_data, Q=>R4);
    REG5: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(5), D=>write_data, Q=>R5);
    REG6: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(6), D=>write_data, Q=>R6);
    REG7: register_4bit port map(clk => clk, reset=>reset, enable=>enable, we=>we_lines(7), D=>write_data, Q=>R7);

   

end Behavioral;