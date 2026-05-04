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
    Port ( instruction : in  STD_LOGIC_VECTOR (11 downto 0);
           zero_flag   : in  STD_LOGIC;
           reg_write_en: out STD_LOGIC;
           reg_write_sel: out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_a  : out STD_LOGIC_VECTOR (2 downto 0);
           read_sel_b  : out STD_LOGIC_VECTOR (2 downto 0);
           alu_sub     : out STD_LOGIC;
           wb_sel_imm  : out STD_LOGIC;
           pc_load     : out STD_LOGIC);
end component;

signal instruction : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
signal zero_flag   : STD_LOGIC := '0';
signal reg_write_en : STD_LOGIC;
signal reg_write_sel : STD_LOGIC_VECTOR(2 downto 0);
signal read_sel_a  : STD_LOGIC_VECTOR(2 downto 0);
signal read_sel_b  : STD_LOGIC_VECTOR(2 downto 0);
signal alu_sub, wb_sel_imm, pc_load : STD_LOGIC;

begin

uut: instruction_decoder
    port map (
        instruction  => instruction,
        zero_flag    => zero_flag,
        reg_write_en => reg_write_en,
        reg_write_sel=> reg_write_sel,
        read_sel_a   => read_sel_a,
        read_sel_b   => read_sel_b,
        alu_sub      => alu_sub,
        wb_sel_imm   => wb_sel_imm,
        pc_load      => pc_load );

stim_proc: process
begin
    instruction <= "000111010000"; zero_flag <= '0'; wait for 10 ns;
    instruction <= "011100000000"; zero_flag <= '0'; wait for 10 ns;
    instruction <= "100100001001"; zero_flag <= '0'; wait for 10 ns;
    instruction <= "111000000101"; zero_flag <= '0'; wait for 10 ns;
    instruction <= "111000000101"; zero_flag <= '1'; wait for 10 ns;
    wait;
end process;

end Behavioral;
