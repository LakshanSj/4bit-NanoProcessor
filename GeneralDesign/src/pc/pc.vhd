----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 09:42:19 AM
-- Design Name: 
-- Module Name: pc - Behavioral
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

entity pc is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pc_load : in STD_LOGIC;
           jump_addr : in STD_LOGIC_VECTOR (2 downto 0);
           pc_out : out STD_LOGIC_VECTOR (2 downto 0));
end pc;

architecture Behavioral of pc is

component pc_register
    port(
        clk   : in std_logic;
        reset : in std_logic;
        D     : in std_logic_vector(2 downto 0);
        Q     : out std_logic_vector(2 downto 0)
    );
end component;

component adder_3bit
    port(
        A : in std_logic_vector(2 downto 0);
        Y : out std_logic_vector(2 downto 0)
    );
end component;

component mux2_3bit
    port(
        sel : in std_logic;
        A   : in std_logic_vector(2 downto 0);
        B   : in std_logic_vector(2 downto 0);
        Y   : out std_logic_vector(2 downto 0)
    );
end component;

signal pc_reg   : std_logic_vector(2 downto 0);
signal pc_plus1 : std_logic_vector(2 downto 0);
signal pc_next  : std_logic_vector(2 downto 0);

begin
-- current PC stored here
U1: pc_register
    port map(
        clk   => clk,
        reset => reset,
        D     => pc_next,
        Q     => pc_reg
    );

-- PC + 1
U2: adder_3bit
    port map(
        A => pc_reg,
        Y => pc_plus1
    );

-- choose next PC
U3: mux2_3bit
    port map(
        sel => pc_load,
        A   => pc_plus1,
        B   => jump_addr,
        Y   => pc_next
    );

pc_out <= pc_reg;
    
end Behavioral;
