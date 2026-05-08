----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 04:19:52 AM
-- Design Name: 
-- Module Name: instruction_decoder_tb - Behavioral
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

entity instruction_decoder_tb is
--  Port ( );
end instruction_decoder_tb;

architecture Behavioral of instruction_decoder_tb is

component instruction_decoder
    Port ( instruction : in  STD_LOGIC_VECTOR (13 downto 0);
           zero_flag   : in  STD_LOGIC;
           reg_write_en: out STD_LOGIC;
           reg_write_sel: out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_a  : out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_b  : out STD_LOGIC_VECTOR (2 downto 0);
           alu_op      : out STD_LOGIC_VECTOR(2 downto 0);
           wb_sel_imm  : out STD_LOGIC;
           pc_load     : out STD_LOGIC);
end component;

signal instruction : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');
signal zero_flag   : STD_LOGIC := '0';
signal reg_write_en : STD_LOGIC;
signal reg_write_sel : STD_LOGIC_VECTOR(2 downto 0);
signal read_sel_a  : STD_LOGIC_VECTOR(2 downto 0);
signal read_sel_b  : STD_LOGIC_VECTOR(2 downto 0);
signal alu_op       : STD_LOGIC_VECTOR(2 downto 0);
signal wb_sel_imm, pc_load : STD_LOGIC;

begin

uut: instruction_decoder
    port map (
        instruction  => instruction,
        zero_flag    => zero_flag,
        reg_write_en => reg_write_en,
        reg_write_sel=> reg_write_sel,
        read_sel_a   => read_sel_a,
        read_sel_b   => read_sel_b,
        alu_op       => alu_op,
        wb_sel_imm   => wb_sel_imm,
        pc_load      => pc_load );

stim_proc: process
begin
    -- Test ADD R1, R2 (opcode 0000, Ra=001, Rb=010)
    instruction <= "00000010010000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test SUB R3, R4 (opcode 0001, Ra=011, Rb=100)
    instruction <= "00010110010000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test CMPU R5, R6 (opcode 0010, Ra=101, Rb=110)
    instruction <= "00101010110000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test CMP R7, R0 (opcode 0011, Ra=111, Rb=000)
    instruction <= "00111110000000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test OR R1, R2 (opcode 0100, Ra=001, Rb=010)
    instruction <= "01000010010000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test AND R3, R4 (opcode 0101, Ra=011, Rb=100)
    instruction <= "01010110010000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test XOR R5, R6 (opcode 0110, Ra=101, Rb=110)
    instruction <= "01101010110000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test NOT R1 (opcode 0111, Ra=001)
    instruction <= "01110010000000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test MOVI R2, d (opcode 1000, Rd=010)
    instruction <= "10000100000000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test NEG R3 (opcode 1001, Rb=011)
    instruction <= "10010110000000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test JZR R1, d with zero_flag = '0' (no jump)
    instruction <= "10100010000000"; zero_flag <= '0'; wait for 10 ns;
    
    -- Test JZR R1, d with zero_flag = '1' (jump)
    instruction <= "10100010000000"; zero_flag <= '1'; wait for 10 ns;
    
    -- Test invalid opcode (should do nothing, all outputs default)
    instruction <= "11110000000000"; zero_flag <= '0'; wait for 10 ns;
    
    wait;
end process;

end Behavioral;
