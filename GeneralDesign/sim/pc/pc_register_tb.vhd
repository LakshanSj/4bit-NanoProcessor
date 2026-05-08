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
        Port ( 
            clk    : in STD_LOGIC;
            enable : in STD_LOGIC;
            reset  : in STD_LOGIC;
            D      : in STD_LOGIC_VECTOR (2 downto 0);
            Q      : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    signal clk_tb    : STD_LOGIC := '0';
    signal enable_tb : STD_LOGIC := '0';
    signal reset_tb  : STD_LOGIC := '0';
    signal D_tb      : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal Q_tb      : STD_LOGIC_VECTOR (2 downto 0);

    -- Clock period definition (100 MHz clock for standard timing)
    constant CLK_PERIOD : time := 10 ns;

begin
    
    uut: pc_register 
        port map (
            clk    => clk_tb,
            enable => enable_tb,
            reset  => reset_tb,
            D      => D_tb,
            Q      => Q_tb
        );

    -- Clock Generation Process
    clk_process : process
    begin
        while now < 200 ns loop -- Limit simulation time to 200 ns
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- index no: 240297E - 111 010 101 010 101 001		
        reset_tb <= '1';
        wait for 15 ns; 
        reset_tb <= '0';
        wait for 10 ns; -- Q should be "000" here

        D_tb <= "001";
        enable_tb <= '0';
        wait for CLK_PERIOD; -- Q should still remain "000"

        enable_tb <= '1';
        wait for CLK_PERIOD; -- Q should update to "101" on the rising edge

        D_tb <= "101";
        wait for CLK_PERIOD; -- Q should update to "011"

        enable_tb <= '0';
        D_tb <= "010";
        wait for CLK_PERIOD * 2; 
        
        enable_tb <= '1';
        wait for CLK_PERIOD;
        
        D_tb <= "111";
        wait for CLK_PERIOD;

        reset_tb <= '1';
        wait for 10 ns; -- Q should instantly drop back to "000"
        reset_tb <= '0';

        wait; 
    end process;

end Behavioral;

