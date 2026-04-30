----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2026 11:51:54 AM
-- Design Name: 
-- Module Name: seven_seg_top - Behavioral
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

entity seven_seg_top is
Port ( 
    Clk_100MHz : in  std_logic;
    sw         : in  std_logic_vector(3 downto 0);   -- data_in
    an         : out std_logic_vector(3 downto 0);   -- AN3..AN0
    seg        : out std_logic_vector(6 downto 0)    -- CA..CG
);
end seven_seg_top;

architecture Behavioral of seven_seg_top is

component seven_seg
        Port (
            data_in : in  std_logic_vector(3 downto 0);
            digit0  : out std_logic_vector(6 downto 0);
            digit1  : out std_logic_vector(6 downto 0)
        );
    end component;

    signal digit0, digit1 : std_logic_vector(6 downto 0);
    signal display_toggle : std_logic := '0';
    signal mux_counter    : unsigned(17 downto 0) := (others => '0');
    
    -- Slow counter to cycle through 0..15
    signal value_counter  : unsigned(25 downto 0) := (others => '0');
    signal number         : unsigned(3 downto 0) := (others => '0');
    signal number_std     : std_logic_vector(3 downto 0);
    
begin

    -- Instantiate the decoder
    u_seg: seven_seg
        port map (
            data_in => number_std,
            digit0  => digit0,
            digit1  => digit1
        );

    number_std <= std_logic_vector(number);

    -- Slow counter: increment number every ~100 million clocks (1 second)
    process(Clk_100MHz)
    begin
        if rising_edge(Clk_100MHz) then
            value_counter <= value_counter + 1;
            -- Change number when counter is 1/4 to have ~0.25s per value (adjust as you want)
            if value_counter = 50000000 then   -- ~0.25 s
                value_counter <= (others => '0');
                number <= number + 1;          -- wraps from 15 to 0 automatically
            end if;
        end if;
    end process;

    -- Clock divider for display multiplexing (~381 Hz)
    process(Clk_100MHz)
    begin
        if rising_edge(Clk_100MHz) then
            mux_counter <= mux_counter + 1;
            if mux_counter = 0 then
                display_toggle <= not display_toggle;
            end if;
        end if;
    end process;

    -- Multiplex anodes and cathodes
    process(display_toggle, digit0, digit1)
    begin
        if display_toggle = '0' then
            an  <= "1110";          -- AN0 active low
            seg <= digit0;
        else
            an  <= "1101";          -- AN1 active low
            seg <= digit1;
        end if;
        -- AN2, AN3 are disabled (high)
    end process;

end Behavioral;
