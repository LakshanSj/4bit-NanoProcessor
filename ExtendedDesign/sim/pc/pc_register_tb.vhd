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

entity pc_register_tb is
--  Port ( );
end pc_register_tb;

architecture Behavioral of pc_register_tb is
component pc_register
    Port ( clk   : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           D     : in  STD_LOGIC_VECTOR (2 downto 0);
           Q     : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal clk   : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal D     : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal Q     : STD_LOGIC_VECTOR(2 downto 0);

begin

uut: pc_register
    port map (
        clk   => clk,
        reset => reset,
        D     => D,
        Q     => Q
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

    reset <= '1'; D <= "111"; wait for 15 ns;
    wait for 15 ns;
    reset <= '0'; D <= "101"; wait for 25 ns;
    wait for 40 ns;
    D <= "010"; wait for 5 ns;
    wait for 25 ns;
    D <= "110"; wait for 30 ns;
    reset <= '1'; D <= "001"; wait for 8 ns;
    reset <= '0'; D <= "011"; wait for 25 ns;
    wait;
end process;

end Behavioral;
