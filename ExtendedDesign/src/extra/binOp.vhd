----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 05:37:23 PM
-- Design Name: 
-- Module Name: operations - Behavioral
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

entity binOp is
    Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
           A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end binOp;

architecture Behavioral of binOp is

begin
    Y(0) <= (A(0) AND NOT B(0) AND NOT I(0)) OR (B(0)AND NOT I(1) AND NOT I(0)) OR (NOT I(1) AND A(0) AND B(0)) OR (NOT A(0) AND I(1) AND I(0)) OR (I(1) AND NOT A(0) AND B(0));
    Y(1) <= (A(1) AND NOT B(1) AND NOT I(0)) OR (B(1)AND NOT I(1) AND NOT I(0)) OR (NOT I(1) AND A(1) AND B(1)) OR (NOT A(1) AND I(1) AND I(0)) OR (I(1) AND NOT A(1) AND B(1));
    Y(2) <= (A(2) AND NOT B(2) AND NOT I(0)) OR (B(2)AND NOT I(1) AND NOT I(0)) OR (NOT I(1) AND A(2) AND B(2)) OR (NOT A(2) AND I(1) AND I(0)) OR (I(1) AND NOT A(2) AND B(2));
    Y(3) <= (A(3) AND NOT B(3) AND NOT I(0)) OR (B(3)AND NOT I(1) AND NOT I(0)) OR (NOT I(1) AND A(3) AND B(3)) OR (NOT A(3) AND I(1) AND I(0)) OR (I(1) AND NOT A(3) AND B(3));
    

end Behavioral;
