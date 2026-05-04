----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 02:24:38 PM
-- Design Name: 
-- Module Name: comparator - Behavioral
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

entity comparator is
Port ( A, B    : in  STD_LOGIC_VECTOR(3 downto 0);
        sign_en : in  STD_LOGIC;
        GT, EQ, LT : out STD_LOGIC
    );
end comparator;

architecture Behavioral of comparator is

signal E : STD_LOGIC_VECTOR(3 downto 0);
    signal GT_u, LT_u : STD_LOGIC;
    signal GT_s, LT_s : STD_LOGIC;

begin

    -- Equality bits
    E(0) <= A(0) xnor B(0);
    E(1) <= A(1) xnor B(1);
    E(2) <= A(2) xnor B(2);
    E(3) <= A(3) xnor B(3);

    EQ <= E(3) and E(2) and E(1) and E(0);

    -- Unsigned comparator
    GT_u <= (A(3) and not B(3)) or
            (E(3) and A(2) and not B(2)) or
            (E(3) and E(2) and A(1) and not B(1)) or
            (E(3) and E(2) and E(1) and A(0) and not B(0));

    LT_u <= (not A(3) and B(3)) or
            (E(3) and not A(2) and B(2)) or
            (E(3) and E(2) and not A(1) and B(1)) or
            (E(3) and E(2) and E(1) and not A(0) and B(0));

    -- Signed comparator
    GT_s <= (not A(3) and B(3)) or
            (E(3) and GT_u);

    LT_s <= (A(3) and not B(3)) or
            (E(3) and LT_u);

    -- Mode selection
    GT <= (sign_en and GT_s) or ((not sign_en) and GT_u);
    LT <= (sign_en and LT_s) or ((not sign_en) and LT_u);

end Behavioral;
