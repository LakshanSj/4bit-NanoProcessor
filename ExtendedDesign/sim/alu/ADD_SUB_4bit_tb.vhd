----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2026 09:42:10 PM
-- Design Name: 
-- Module Name: ADD_SUB_4bit_tb - Behavioral
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

entity ADD_SUB_4bit_tb is
--  Port ( );
end ADD_SUB_4bit_tb;

architecture Behavioral of ADD_SUB_4bit_tb is

component ADD_SUB_4bit
    Port ( A        : in  STD_LOGIC_VECTOR (3 downto 0);
           B        : in  STD_LOGIC_VECTOR (3 downto 0);
           alu_sel  : in  STD_LOGIC;
           Y        : out STD_LOGIC_VECTOR (3 downto 0);
           carry    : out STD_LOGIC;
           overflow : out STD_LOGIC;
           zero     : out STD_LOGIC);
end component;

signal A, B      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal alu_sel   : STD_LOGIC := '0';
signal Y         : STD_LOGIC_VECTOR(3 downto 0);
signal carry     : STD_LOGIC;
signal overflow  : STD_LOGIC;
signal zero      : STD_LOGIC;

begin

UUT: ADD_SUB_4bit
    port map (
        A        => A,
        B        => B,
        alu_sel  => alu_sel,
        Y        => Y,
        carry    => carry,
        overflow => overflow,
        zero     => zero
    );

-- Stimulus process
stim_proc: process
begin
    -- ========== ADDITION TESTS (alu_sel = '0') ==========
    alu_sel <= '0';
    A <= "0101"; B <= "0011"; wait for 10 ns;
    A <= "1100"; B <= "0101"; wait for 10 ns;
    A <= "0111"; B <= "0001"; wait for 10 ns;
    A <= "0000"; B <= "0000"; wait for 10 ns;
    A <= "0111"; B <= "0001"; wait for 10 ns;

    -- ========== SUBTRACTION TESTS (alu_sel = '1') ==========
    alu_sel <= '1';
    A <= "1001"; B <= "0100"; wait for 10 ns;
    A <= "0101"; B <= "0101"; wait for 10 ns;
    A <= "0010"; B <= "1000"; wait for 10 ns;
    A <= "1000"; B <= "0001"; wait for 10 ns;
    A <= "1111"; B <= "1111"; wait for 10 ns;
    wait;
end process;

end Behavioral;
