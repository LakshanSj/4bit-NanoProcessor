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

entity system_top is
    Port (
        Clk_100MHz : in  std_logic;
        btnC       : in  std_logic; 
        btnU       : in  std_logic;
        sw         : in  std_logic_vector(15 downto 0);
        seg        : out std_logic_vector(6 downto 0);
        an         : out std_logic_vector(3 downto 0);
        led        : out std_logic_vector(8 downto 0)
    );
end system_top;

architecture Behavioral of system_top is

    component Nanoprocessor
        Port (
            Clk_100MHz : in  std_logic;
            reset      : in  std_logic;
            mode_sel   : in  std_logic;
            sw_inst    : in  std_logic_vector(13 downto 0);
            btn_step   : in  std_logic;
            result     : out std_logic_vector(3 downto 0);
            zero       : out std_logic;
            overflow   : out std_logic;
            greater    : out std_logic;
            equal      : out std_logic;
            lower      : out std_logic
        );
    end component;

    component seven_seg
        Port (
            data_in : in  std_logic_vector(3 downto 0);
            digit0  : out std_logic_vector(6 downto 0);
            digit1  : out std_logic_vector(6 downto 0)
        );
    end component;

    signal result  : std_logic_vector(3 downto 0);
    signal zero    : std_logic;
    signal ovf     : std_logic;

    signal digit0, digit1 : std_logic_vector(6 downto 0);
    signal toggle : std_logic := '0';
    signal refresh_counter : unsigned(16 downto 0) := (others => '0');

begin

    U_CPU: Nanoprocessor
        port map (
            Clk_100MHz => Clk_100MHz,
            reset      => btnC,
            mode_sel   => sw(15),    
            sw_inst    => sw(13 downto 0), 
            btn_step   => btnU,         
            result     => result,
            zero       => led(4),
            overflow   => led(5),
            greater   => led(6),
            equal     => led(7),
            lower     => led(8)
        );

    U_SEG: seven_seg
        port map (
            data_in => result,
            digit0  => digit0,
            digit1  => digit1
        );

    led(3 downto 0) <= result;

    process(Clk_100MHz)
    begin
        if rising_edge(Clk_100MHz) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    toggle <= refresh_counter(16);

    process(toggle, digit0, digit1)
    begin
        if toggle = '0' then
            an  <= "1110";
            seg <= digit0;
        else
            an  <= "1101";
            seg <= digit1;
        end if;
    end process;

end Behavioral;