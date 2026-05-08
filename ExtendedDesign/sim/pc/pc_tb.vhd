----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 09:45:08 AM
-- Design Name: 
-- Module Name: pc_tb - Behavioral
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

entity pc_tb is
--  Port ( );
end pc_tb;

architecture Behavioral of pc_tb is
component pc
        Port ( clk       : in  STD_LOGIC;
               enable    : in  STD_LOGIC;
               reset     : in  STD_LOGIC;
               pc_load   : in  STD_LOGIC;
               jump_addr : in  STD_LOGIC_VECTOR (2 downto 0);
               pc_out    : out STD_LOGIC_VECTOR (2 downto 0));
    end component;

    signal clk       : STD_LOGIC := '0';
    signal enable    : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '0';
    signal pc_load   : STD_LOGIC := '0';
    signal jump_addr : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal pc_out    : STD_LOGIC_VECTOR(2 downto 0);

begin

    uut: pc
        port map (
            clk       => clk,
            enable    => enable,
            reset     => reset,
            pc_load   => pc_load,
            jump_addr => jump_addr,
            pc_out    => pc_out
        );

    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        enable <= '0';
        reset <= '1';   
        pc_load <= '0'; jump_addr <= "001"; wait for 25 ns;
        reset <= '0';   
        enable <= '1';                      wait for 70 ns;
                        
        pc_load <= '1'; jump_addr <= "110"; wait for 25 ns;
        pc_load <= '0';                     wait for 70 ns;
        
        -- index No : 240297 - 111 010 101 010 101 001
        
        pc_load <= '1'; jump_addr <= "111"; wait for 25 ns; 
        pc_load <= '0';                     wait for 70 ns;

        pc_load <= '1'; jump_addr <= "010"; wait for 25 ns; 
        pc_load <= '0';                     wait for 70 ns;

        pc_load <= '1'; jump_addr <= "101"; wait for 25 ns; 
        pc_load <= '0';                     wait for 70 ns;

        pc_load <= '1'; jump_addr <= "010"; wait for 25 ns; 
        pc_load <= '0';                     wait for 70 ns;
        
        pc_load <= '1'; jump_addr <= "001"; wait for 25 ns; 
        pc_load <= '0';                     wait for 70 ns;
                        
        reset <= '1';wait for 25 ns;
        wait;
    end process;

end Behavioral;

