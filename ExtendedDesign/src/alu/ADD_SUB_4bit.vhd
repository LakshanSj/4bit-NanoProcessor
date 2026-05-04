----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 09:34:53 PM
-- Design Name: 
-- Module Name: ADD_SUB_4bit - Behavioral
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

entity ADD_SUB_4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           alu_sel : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0);
           carry : out STD_LOGIC;
           overflow : out STD_LOGIC;
           zero : out STD_LOGIC);
end ADD_SUB_4bit;

architecture Behavioral of ADD_SUB_4bit is
component RCA_4bit
    port(
        A     : in  std_logic_vector(3 downto 0);
        B     : in  std_logic_vector(3 downto 0);
        C_in  : in  std_logic;
        S     : out std_logic_vector(3 downto 0);
        C_out : out std_logic
    );
end component;
signal B_mod  : std_logic_vector(3 downto 0);
signal sum    : std_logic_vector(3 downto 0);
signal c_out  : std_logic;

begin

B_mod <= B xor (alu_sel & alu_sel & alu_sel & alu_sel);

U1: rca_4bit
    port map(
        A     => A,
        B     => B_mod,
        C_in  => alu_sel,  -- 0 for add, 1 for subtract
        S     => sum,
        C_out => c_out
    );

Y     <= sum;
carry <= c_out;
overflow <= (A(3) xor sum(3)) and (B_mod(3) xor sum(3));
zero <= '1' when sum = "0000" else '0';

end Behavioral;
