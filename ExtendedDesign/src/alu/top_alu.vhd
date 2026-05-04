----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2026 03:50:33 PM
-- Design Name: 
-- Module Name: top_alu - Behavioral
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

entity top_alu is
 Port (   A         : in  STD_LOGIC_VECTOR (3 downto 0);
         B         : in  STD_LOGIC_VECTOR (3 downto 0);
         alu_op    : in  STD_LOGIC_VECTOR (2 downto 0);
         Y         : out STD_LOGIC_VECTOR (3 downto 0);
         carry     : out STD_LOGIC;
         overflow  : out STD_LOGIC;
         zero      : out STD_LOGIC;
         GT        : out STD_LOGIC;
         EQ        : out STD_LOGIC;
         LT        : out STD_LOGIC);
end top_alu;

architecture Behavioral of top_alu is

component binOp
       Port ( I : in  STD_LOGIC_VECTOR (1 downto 0);
              A : in  STD_LOGIC_VECTOR (3 downto 0);
              B : in  STD_LOGIC_VECTOR (3 downto 0);
              Y : out STD_LOGIC_VECTOR (3 downto 0));
   end component;

   component ADD_SUB_4bit
       Port ( A        : in  STD_LOGIC_VECTOR (3 downto 0);
              B        : in  STD_LOGIC_VECTOR (3 downto 0);
              alu_sel  : in  STD_LOGIC;
              Y        : out STD_LOGIC_VECTOR (3 downto 0);
              carry    : out STD_LOGIC;
              overflow : out STD_LOGIC;
              zero     : out STD_LOGIC);
   end component;
   
   component comparator
   Port ( A, B    : in  STD_LOGIC_VECTOR(3 downto 0);
           sign_en : in  STD_LOGIC;
           GT, EQ, LT : out STD_LOGIC
       );
   end component;

   signal logic_result   : STD_LOGIC_VECTOR (3 downto 0);
   signal arith_result   : STD_LOGIC_VECTOR (3 downto 0);
   signal arith_carry    : STD_LOGIC;
   signal arith_overflow : STD_LOGIC;
   signal arith_zero     : STD_LOGIC;
   signal logic_ctrl     : STD_LOGIC_VECTOR (1 downto 0);
   signal sub_sel        : STD_LOGIC;
   signal cmp_GT, cmp_EQ, cmp_LT : STD_LOGIC;

begin

   logic_ctrl <= alu_op(1 downto 0);

   logic_unit: binOp
       port map (
           I => logic_ctrl,
           A => A,
           B => B,
           Y => logic_result
       );

   sub_sel <= '1' when alu_op = "001" else '0';

   arith_unit: ADD_SUB_4bit
       port map (
           A        => A,
           B        => B,
           alu_sel  => sub_sel,
           Y        => arith_result,
           carry    => arith_carry,
           overflow => arith_overflow,
           zero     => arith_zero
       );
       
    comp_unit: comparator
       port map (
           A        => A,
           B        => B,
           sign_en  => alu_op(0),
           GT       => cmp_GT,
           EQ       => cmp_EQ,
           LT       => cmp_LT );

   process(alu_op, logic_result, arith_result, arith_carry, arith_overflow, arith_zero, cmp_GT, cmp_EQ, cmp_LT)
   begin
       case alu_op is
           when "000" | "001" =>
               Y        <= arith_result;
               carry    <= arith_carry;
               overflow <= arith_overflow;
               zero     <= arith_zero;
               GT       <= '0';
               EQ       <= '0';
               LT       <= '0';
               
           when "010" | "011" =>
               Y        <= "0000";
               carry    <= '0';
               overflow <= '0';
               zero     <= '0';
               GT       <= cmp_GT;
               EQ       <= cmp_EQ;
               LT       <= cmp_LT;
               
           when "100" | "101" | "110" | "111" =>
               Y        <= logic_result;
               GT       <= '0';
               EQ       <= '0';
               LT       <= '0';
               carry    <= '0';
               overflow <= '0';
               if logic_result = "0000" then
                   zero <= '1';
               else
                   zero <= '0';
               end if;
           when others =>
               Y        <= (others => '0');
               carry    <= '0';
               overflow <= '0';
               zero     <= '0';
       end case;
   end process;

end Behavioral;
