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
    Port ( instruction : in  STD_LOGIC_VECTOR (13 downto 0);
           zero_flag   : in  STD_LOGIC;   -- '1' when the tested register is zero
           reg_write_en: out STD_LOGIC;
           reg_write_sel: out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_a  : out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_b  : out STD_LOGIC_VECTOR (2 downto 0);
           alu_op     : out STD_LOGIC_VECTOR(2 downto 0);
           wb_sel_imm  : out STD_LOGIC;    -- '1' to write immediate, '0' for ALU result
           pc_load     : out STD_LOGIC);   -- jump enable to program counter
end instruction_decoder;

architecture Behavioral of instruction_decoder is

signal opcode : std_logic_vector(3 downto 0);
begin
    opcode <= instruction(13 downto 10);

    process(opcode, instruction, zero_flag)
    begin
        -- Defaults (no operation)
        reg_write_en <= '0';
        reg_write_sel <= "000";
        read_sel_a <= "000";
        read_sel_b <= "000";
        alu_op <= "000";
        wb_sel_imm <= '0';
        pc_load <= '0';

        case opcode is
            when "0000" =>   -- ADD Ra, Rb
                read_sel_a <= instruction(9 downto 7);  -- Ra
                read_sel_b <= instruction(6 downto 4);  -- Rb
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- destination Ra
                alu_op <= opcode(2 downto 0);
                wb_sel_imm <= '0';
                
            when "0001" =>   -- SUB Ra, Rb
                read_sel_a <= instruction(9 downto 7);  -- Ra
                read_sel_b <= instruction(6 downto 4);  -- Rb
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- destination Ra
                alu_op <= opcode(2 downto 0);
                wb_sel_imm <= '0';
                
            when "0010" =>   -- CMPU Ra, Rb
                read_sel_a <= instruction(9 downto 7);                   
                read_sel_b <= instruction(6 downto 4); 
                reg_write_en <= '0';
                reg_write_sel <= instruction(9 downto 7);
                alu_op <= opcode(2 downto 0);
                wb_sel_imm <= '0';
                                
            when "0011" =>   -- CMP Ra, Rb
                read_sel_a <= instruction(9 downto 7);             
                read_sel_b <= instruction(6 downto 4); 
                reg_write_en <= '0';
                reg_write_sel <= instruction(9 downto 7); 
                alu_op <= opcode(2 downto 0);
                wb_sel_imm <= '0';
                
             when "0100" =>   -- OR
                    read_sel_a <= instruction(9 downto 7);
                    read_sel_b <= instruction(6 downto 4);
                    reg_write_en <= '1';
                    reg_write_sel <= instruction(9 downto 7);
                    alu_op <= opcode(2 downto 0);

             when "0101" =>   -- AND
                    read_sel_a <= instruction(9 downto 7);
                    read_sel_b <= instruction(6 downto 4);
                    reg_write_en <= '1';
                    reg_write_sel <= instruction(9 downto 7);
                    alu_op <= opcode(2 downto 0);
        
            when "0110" =>   -- XOR
                read_sel_a <= instruction(9 downto 7);
                read_sel_b <= instruction(6 downto 4);
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7);
                alu_op <= opcode(2 downto 0);
        
            when "0111" =>   -- NOT
                read_sel_a <= instruction(9 downto 7);
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7);
                alu_op <= opcode(2 downto 0);
                
            when "1000" =>   -- MOVI R, d
                read_sel_a <= "000";
                read_sel_b <= "000";
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- destination register
                wb_sel_imm <= '1';                        -- write immediate value
                
            when "1001" =>   -- NEG R
                read_sel_a <= "000";                    -- R0 (hardwired to 0)
                read_sel_b <= instruction(9 downto 7);  -- R
                reg_write_en <= '1';
                reg_write_sel <= instruction(9 downto 7); -- same R
                alu_op <= "001";
                wb_sel_imm <= '0';

            when "1010" =>   -- JZR R, d
                read_sel_a <= instruction(9 downto 7);    -- register to test
                read_sel_b <= "000";
                reg_write_en <= '0';
                pc_load <= zero_flag;

            when others =>
                null;
        end case;
    end process;
end Behavioral;
