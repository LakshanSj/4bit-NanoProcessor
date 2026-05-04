----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2026 11:23:55 AM
-- Design Name: 
-- Module Name: 7seg - Behavioral
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

entity seven_seg is
    Port (
       data_in   : in  std_logic_vector(3 downto 0);
       digit0    : out std_logic_vector(6 downto 0); -- right (LSB)
       digit1    : out std_logic_vector(6 downto 0)  -- left (sign)
    );
end seven_seg;

architecture Behavioral of seven_seg is
   constant SEG_0     : std_logic_vector(6 downto 0) := "1000000";
   constant SEG_1     : std_logic_vector(6 downto 0) := "1111001";
   constant SEG_2     : std_logic_vector(6 downto 0) := "0100100";
   constant SEG_3     : std_logic_vector(6 downto 0) := "0110000";
   constant SEG_4     : std_logic_vector(6 downto 0) := "0011001";
   constant SEG_5     : std_logic_vector(6 downto 0) := "0010010";
   constant SEG_6     : std_logic_vector(6 downto 0) := "0000010";
   constant SEG_7     : std_logic_vector(6 downto 0) := "1111000";
   constant SEG_8     : std_logic_vector(6 downto 0) := "0000000";

   constant SEG_MINUS : std_logic_vector(6 downto 0) := "0111111";
   constant SEG_BLANK : std_logic_vector(6 downto 0) := "1111111";

   signal abs_val : std_logic_vector(3 downto 0);
   
begin
-- absolute value for negative numbers (2's complement)
    abs_val <= std_logic_vector(unsigned(-signed(data_in))) when data_in(3) = '1'
               else data_in;

    process(data_in, abs_val)
    begin
        -- default
        digit0 <= SEG_BLANK;
        digit1 <= SEG_BLANK;

        -- sign
        if data_in(3) = '1' then
            digit1 <= SEG_MINUS;
        end if;

        -- magnitude (0-7 only)
        case abs_val is
            when "0000" => digit0 <= SEG_0;
            when "0001" => digit0 <= SEG_1;
            when "0010" => digit0 <= SEG_2;
            when "0011" => digit0 <= SEG_3;
            when "0100" => digit0 <= SEG_4;
            when "0101" => digit0 <= SEG_5;
            when "0110" => digit0 <= SEG_6;
            when "0111" => digit0 <= SEG_7;
            when others => digit0 <= SEG_8;
        end case;

    end process;

end Behavioral;
