----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2026 11:36:30 AM
-- Design Name: 
-- Module Name: seven_seg_tb - Behavioral
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

entity seven_seg_tb is
--  Port ( );
end seven_seg_tb;

architecture Behavioral of seven_seg_tb is

 component seven_seg
        Port (
            data_in : in  std_logic_vector(3 downto 0);
            digit0  : out std_logic_vector(6 downto 0);
            digit1  : out std_logic_vector(6 downto 0)
        );
    end component;

    signal data_in : std_logic_vector(3 downto 0) := (others => '0');
    signal digit0  : std_logic_vector(6 downto 0);
    signal digit1  : std_logic_vector(6 downto 0);

begin

    uut: seven_seg
        port map (
            data_in => data_in,
            digit0  => digit0,
            digit1  => digit1
        );

    stim_proc: process
    begin
        for i in 0 to 15 loop
            data_in <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
        end loop;
        wait;
    end process;
end Behavioral;
