----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2026 11:44:38 PM
-- Design Name: 
-- Module Name: register_bank_tb - Behavioral
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

entity register_bank_tb is
--  Port ( );
end register_bank_tb;

architecture Behavioral of register_bank_tb is

component register_bank
        port(
            clk, reset, enable : in std_logic;
            write_en    : in std_logic;
            write_sel   : in std_logic_vector(2 downto 0);
            write_data  : in std_logic_vector(3 downto 0);
            R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(3 downto 0));
    end component;

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal enable     : std_logic := '0';
    signal write_en   : std_logic := '0';
    signal write_sel  : std_logic_vector(2 downto 0) := "000";
    signal write_data : std_logic_vector(3 downto 0) := "0000";
    signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(3 downto 0);

begin

    uut: register_bank
        port map (
            clk        => clk,
            reset      => reset,
            enable     => enable,
            write_en   => write_en,
            write_sel  => write_sel,
            write_data => write_data,
            R0         => R0,
            R1         => R1,
            R2         => R2,
            R3         => R3,
            R4         => R4,
            R5         => R5,
            R6         => R6,
            R7         => R7
        );

    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        reset <= '1'; enable <= '0'; write_en <= '0'; wait for 25 ns;
        reset <= '0'; enable <= '1'; wait for 10 ns;

        write_en <= '1'; write_sel <= "011"; write_data <= "1010"; wait for 20 ns;
        write_en <= '0'; wait for 10 ns;

        write_en <= '1'; write_sel <= "101"; write_data <= "0101"; wait for 20 ns;
        write_en <= '0'; wait for 10 ns;

        write_en <= '1'; write_sel <= "000"; write_data <= "1111"; wait for 20 ns;
        write_en <= '0'; wait for 10 ns;

        enable <= '0';
        write_en <= '1'; write_sel <= "010"; write_data <= "0011"; wait for 20 ns;
        write_en <= '0'; wait for 10 ns;
        enable <= '1';

        reset <= '1'; wait for 20 ns;
        reset <= '0'; wait for 20 ns;

        wait;
    end process;

end Behavioral;
