----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2026 08:19:28 PM
-- Design Name: 
-- Module Name: inst_selector - Behavioral
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

entity inst_selector is
    Port (
        clk       : in  STD_LOGIC;
        enable    : in  STD_LOGIC;
        mode_sel  : in  STD_LOGIC;  -- 0 = ROM, 1 = switches
        rom_inst  : in  STD_LOGIC_VECTOR (13 downto 0);
        sw_inst   : in  STD_LOGIC_VECTOR (13 downto 0);
        inst_out  : out STD_LOGIC_VECTOR (13 downto 0)
    );
end inst_selector;

architecture Behavioral of inst_selector is
    signal inst_reg : STD_LOGIC_VECTOR(13 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if mode_sel = '0' then
                    inst_reg <= rom_inst;
                else
                    inst_reg <= sw_inst;
                end if;
            end if;
        end if;
    end process;

    inst_out <= inst_reg;

end Behavioral;
