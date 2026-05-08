----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 04:15:47 AM
-- Design Name: 
-- Module Name: instruction_decoder - Behavioral
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

entity instruction_decoder is
    Port ( instruction : in  STD_LOGIC_VECTOR (11 downto 0);
           zero_flag   : in  STD_LOGIC;   -- '1' when the tested register is zero
           reg_write_en: out STD_LOGIC;
           reg_write_sel: out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_a  : out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_b  : out STD_LOGIC_VECTOR (2 downto 0);
           alu_sub     : out STD_LOGIC;    -- '1' for subtract, '0' for add
           wb_sel_imm  : out STD_LOGIC;    -- '1' to write immediate, '0' for ALU result
           pc_load     : out STD_LOGIC);   -- jump enable to program counter
end instruction_decoder;

architecture Behavioral of instruction_decoder is

signal opcode : std_logic_vector(1 downto 0);
begin
    opcode <= instruction(11 downto 10);

    process(opcode, instruction, zero_flag)
    begin
        -- Defaults (no operation)
        reg_write_en <= '0';
        reg_write_sel <= "000";
        read_sel_a <= "000";
        read_sel_b <= "000";
        alu_sub <= '0';
        wb_sel_imm <= '0';
        pc_load <= '0';

        case opcode is
            when "00" =>   -- ADD Ra, Rb
                read_sel_a <= instruction(9 downto 7);  -- Ra
                read_sel_b <= instruction(6 downto 4);  -- Rb
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- destination Ra
                alu_sub <= '0';
                wb_sel_imm <= '0';

            when "01" =>   -- NEG R
                read_sel_a <= "000";                    -- R0 (hardwired to 0)
                read_sel_b <= instruction(9 downto 7);  -- R
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- same R
                alu_sub <= '1';
                wb_sel_imm <= '0';

            when "10" =>   -- MOVI R, d
                read_sel_a <= "000";
                read_sel_b <= "000";
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- destination register
                wb_sel_imm <= '1';                        -- write immediate value

            when "11" =>   -- JZR R, d
                read_sel_a <= instruction(9 downto 7);    -- register to test
                read_sel_b <= "000";
                reg_write_en <= '0';
                if zero_flag = '1' then
                    pc_load <= '1';
                end if;

            when others =>
                null;
        end case;
    end process;
end Behavioral;
