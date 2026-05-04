----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 12:58:18 AM
-- Design Name: 
-- Module Name: flags_tb - Behavioral
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

entity flags_tb is
--  Port ( );
end flags_tb;

architecture Behavioral of flags_tb is

component flags
        Port (
            clk          : in  STD_LOGIC;
            enable       : in STD_LOGIC;
            reset        : in  STD_LOGIC;
            flag_en      : in  STD_LOGIC;
            cmp_en       : in STD_LOGIC;
            alu_zero     : in  STD_LOGIC;
            alu_overflow : in  STD_LOGIC;
            alu_GT       : in  STD_LOGIC;
            alu_EQ       : in  STD_LOGIC;
            alu_LT       : in  STD_LOGIC;
            Z            : out STD_LOGIC;
            V            : out STD_LOGIC;
            GT           : out STD_LOGIC;
            EQ           : out STD_LOGIC;
            LT           : out STD_LOGIC
        );
    end component;

    signal clk          : STD_LOGIC := '0';
    signal enable       : STD_LOGIC := '0';
    signal reset        : STD_LOGIC := '0';
    signal flag_en      : STD_LOGIC := '0';
    signal cmp_en       : STD_LOGIC := '0';
    signal alu_zero     : STD_LOGIC := '0';
    signal alu_overflow : STD_LOGIC := '0';
    signal alu_GT       : STD_LOGIC := '0';
    signal alu_EQ       : STD_LOGIC := '0';
    signal alu_LT       : STD_LOGIC := '0';
    signal Z, V, GT, EQ, LT : STD_LOGIC;

begin

    uut: flags
        port map (
            clk          => clk,
            enable       => enable,
            reset        => reset,
            flag_en      => flag_en,
            cmp_en       => cmp_en,
            alu_zero     => alu_zero,
            alu_overflow => alu_overflow,
            alu_GT       => alu_GT,
            alu_EQ       => alu_EQ,
            alu_LT       => alu_LT,
            Z            => Z,
            V            => V,
            GT           => GT,
            EQ           => EQ,
            LT           => LT
        );

    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    stim_proc : process
    begin
        -- Reset
        reset <= '1';
        enable <= '0';
        flag_en <= '0';
        cmp_en  <= '0';
        alu_zero <= '1'; alu_overflow <= '1'; alu_GT <= '1'; alu_EQ <= '1'; alu_LT <= '1';
        wait for 25 ns;

        -- Release reset
        reset <= '0';
        wait for 15 ns;

        -- Enable update, but enable = 0 initially
        enable <= '0';
        flag_en <= '1';
        cmp_en <= '1';
        alu_zero <= '1'; alu_overflow <= '0'; alu_GT <= '0'; alu_EQ <= '1'; alu_LT <= '0';
        wait for 20 ns;  

        enable <= '1';
        wait for 25 ns;  

        alu_zero <= '0'; alu_overflow <= '1'; alu_GT <= '1'; alu_EQ <= '0'; alu_LT <= '1';
        wait for 25 ns;

        flag_en <= '0';
        cmp_en <= '0';
        alu_zero <= '1'; alu_overflow <= '1'; alu_GT <= '0'; alu_EQ <= '0'; alu_LT <= '0';
        wait for 30 ns;

        flag_en <= '1';
        wait for 25 ns;

        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 30 ns;

        wait;
    end process;

end behavioral;
