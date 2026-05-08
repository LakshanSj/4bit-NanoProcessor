----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 09:30:34 AM
-- Design Name: 
-- Module Name: pc_register_tb - Behavioral
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

entity register_4bit_tb is
--  Port ( );
end register_4bit_tb;

architecture Behavioral of register_4bit_tb is
component register_4bit
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable : in STD_LOGIC;
               we : in STD_LOGIC;
               D : in STD_LOGIC_VECTOR (3 downto 0);
               Q : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal clk    : STD_LOGIC := '0';
    signal reset  : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal we     : STD_LOGIC := '0';
    signal D      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Q      : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut: register_4bit
        port map (
            clk    => clk,
            reset  => reset,
            enable => enable,
            we     => we,
            D      => D,
            Q      => Q
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
    --index no : 240312A - 111 010 101 010 111 000 
                       --  0011 1010 1010 1011 1000 
                       
        reset <= '1'; enable <= '0'; we <= '0'; D <= "1000"; wait for 25 ns;
        reset <= '0'; wait for 10 ns;

        enable <= '1'; we <= '1'; D <= "1011"; wait for 20 ns;
        we <= '0'; D <= "1010"; wait for 20 ns;
        we <= '1'; D <= "0011"; wait for 20 ns;
        enable <= '0'; we <= '1'; D <= "1000"; wait for 20 ns;

        reset <= '1'; wait for 15 ns;
        reset <= '0'; wait for 15 ns;

        enable <= '1'; we <= '1'; D <= "1010"; wait for 20 ns;

        wait;
    end process;

end Behavioral;

