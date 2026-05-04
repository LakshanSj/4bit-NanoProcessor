----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 09:07:50 PM
-- Design Name: 
-- Module Name: RCA_4bit - Behavioral
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

entity RCA_4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           C_out : out STD_LOGIC);
end RCA_4bit;

architecture Behavioral of RCA_4bit is

component FA
    port (
        A     : in std_logic;
        B     : in std_logic;
        C_in  : in std_logic;
        S     : out std_logic;
        C_out : out std_logic
    );
end component;
signal C : std_logic_vector(4 downto 0);

begin
C(0) <= C_in;
FA_0: FA port map(A => A(0), B => B(0), C_in => C(0), S => S(0), C_out => C(1));
FA_1: FA port map(A => A(1), B => B(1), C_in => C(1), S => S(1), C_out => C(2));
FA_2: FA port map(A => A(2), B => B(2), C_in => C(2), S => S(2), C_out => C(3));
FA_3: FA port map(A => A(3), B => B(3), C_in => C(3), S => S(3), C_out => C(4));
C_out <= C(4);

end Behavioral;
