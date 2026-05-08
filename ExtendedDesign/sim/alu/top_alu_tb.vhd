----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2026 03:55:58 PM
-- Design Name: 
-- Module Name: top_alu_tb - Behavioral
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

entity top_alu_tb is
--  Port ( );
end top_alu_tb;

architecture Behavioral of top_alu_tb is

component top_alu
        Port ( A         : in  STD_LOGIC_VECTOR (3 downto 0);
               B         : in  STD_LOGIC_VECTOR (3 downto 0);
               alu_op    : in  STD_LOGIC_VECTOR (2 downto 0);
               Y         : out STD_LOGIC_VECTOR (3 downto 0);
               carry     : out STD_LOGIC;
               overflow  : out STD_LOGIC;
               zero      : out STD_LOGIC;
               GT        : out STD_LOGIC;
               EQ        : out STD_LOGIC;
               LT        : out STD_LOGIC);
    end component;

    signal A, B     : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal alu_op   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Y        : STD_LOGIC_VECTOR(3 downto 0);
    signal carry    : STD_LOGIC;
    signal overflow : STD_LOGIC;
    signal zero     : STD_LOGIC;
    signal GT, EQ, LT : STD_LOGIC;

begin

    uut: top_alu
        port map (
            A        => A,
            B        => B,
            alu_op   => alu_op,
            Y        => Y,
            carry    => carry,
            overflow => overflow,
            zero     => zero,
            GT       => GT,
            EQ       => EQ,
            LT       => LT
        );

    stim_proc : process
    begin
    --index no : 240288D - 0011 1010 1010 1010 0000
            -- : 240294R - 0011 1010 1010 1010 0110 
            -- : 240297E - 0011 1010 1010 1010 1001
            -- : 240312A - 0011 1010 1010 1011 1000
    
        -- Unsigned compare (alu_op = "010")
        alu_op <= "010";
        -- 0 < 10
        A <= "0000"; B <= "1010"; wait for 10 ns;
        -- 10 > 16
        A <= "1010"; B <= "0110"; wait for 10 ns;
        -- 9 < 10
        A <= "1001"; B <= "1010"; wait for 10 ns;
        -- 8 < 11
        A <= "1000"; B <= "1011"; wait for 10 ns;
        -- 7 = 7 
        A <= "0111"; B <= "0111"; wait for 10 ns;
        

        -- Signed compare (alu_op = "011")
        alu_op <= "011";
        -- -1 < 1 (1111 vs 0001)
        A <= "1111"; B <= "0001"; wait for 10 ns;
        -- 2 > -3 (0010 vs 1101)
        A <= "0010"; B <= "1101"; wait for 10 ns;
        -- -4 = -4 (1100 vs 1100)
        A <= "1100"; B <= "1100"; wait for 10 ns;

        -- Edge: 0 vs 0
        A <= "0000"; B <= "0000";
        alu_op <= "010"; wait for 10 ns;
        alu_op <= "011"; wait for 10 ns;

        wait;
    end process;

end behavioral;


