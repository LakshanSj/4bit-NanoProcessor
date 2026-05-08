----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 01:50:49 PM
-- Design Name: 
-- Module Name: Nanoprocessor - Behavioral
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

entity Nanoprocessor is
    Port (
        Clk_100MHz : in  STD_LOGIC; 
        reset  : in  std_logic;
        result : out std_logic_vector(3 downto 0); -- R7
        zero   : out std_logic;
        overflow  : out std_logic
    );
end Nanoprocessor;

architecture Behavioral of Nanoprocessor is

    component program_rom 
    Port ( 
        addr : in  std_logic_vector(2 downto 0);
        data : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component instruction_decoder 
        Port ( 
            instruction    : in  STD_LOGIC_VECTOR (11 downto 0);
            zero_flag      : in  STD_LOGIC;
            reg_write_en   : out STD_LOGIC;
            reg_write_sel  : out STD_LOGIC_VECTOR (2 downto 0);
            read_sel_a     : out STD_LOGIC_VECTOR (2 downto 0);
            read_sel_b     : out STD_LOGIC_VECTOR (2 downto 0);
            alu_sub        : out STD_LOGIC;
            wb_sel_imm     : out STD_LOGIC;
            pc_load        : out STD_LOGIC
        );
    end component;
    
    component ADD_SUB_4bit 
        Port ( 
            A      : in STD_LOGIC_VECTOR (3 downto 0);
            B      : in STD_LOGIC_VECTOR (3 downto 0);
            alu_sel: in STD_LOGIC;
            Y      : out STD_LOGIC_VECTOR (3 downto 0);
            carry  : out STD_LOGIC;
            overflow : out STD_LOGIC;
            zero   : out STD_LOGIC
        );
    end component;
    
    component flags
         Port (
           clk      : in  STD_LOGIC;
           enable   : in STD_LOGIC;
           reset    : in  STD_LOGIC;
           flag_en       : in  STD_LOGIC;
           alu_zero : in  STD_LOGIC;
           alu_overflow : in STD_LOGIC;
           Z        : out STD_LOGIC;
           V        : out STD_LOGIC
       );
   end component;
    
    component register_bank 
        port(
            clk, reset , enable : in std_logic;
            write_en    : in std_logic;
            write_sel   : in std_logic_vector(2 downto 0);
            write_data  : in std_logic_vector(3 downto 0);
            R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector (3 downto 0)
        );
    end component; 
    
    component mux2_4bit 
        Port ( 
            sel : in STD_LOGIC;
            A   : in STD_LOGIC_VECTOR (3 downto 0);
            B   : in STD_LOGIC_VECTOR (3 downto 0);
            Y   : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    
    component mux8_4bit
        port(
            sel : in std_logic_vector(2 downto 0);
            I0, I1, I2, I3, I4, I5, I6, I7 : in std_logic_vector(3 downto 0);
            Y : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component slow_clock
        port ( clk_in : in std_logic;
               enable : out std_logic );
    end component;
    
    component pc 
        Port ( 
            clk       : in STD_LOGIC;
            enable    : in STD_LOGIC;
            reset     : in STD_LOGIC;
            pc_load   : in STD_LOGIC;
            jump_addr : in STD_LOGIC_VECTOR (2 downto 0);
            pc_out    : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;  

    -- internal signals
    signal pc_addr        : STD_LOGIC_VECTOR(2 downto 0);
    signal instruction    : STD_LOGIC_VECTOR(11 downto 0);
    signal jump_addr      : STD_LOGIC_VECTOR(2 downto 0);
    signal imm_val        : STD_LOGIC_VECTOR(3 downto 0);

    signal R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(3 downto 0);
    signal reg_write_en   : STD_LOGIC;
    signal reg_write_sel  : STD_LOGIC_VECTOR(2 downto 0);
    signal reg_write_data : STD_LOGIC_VECTOR(3 downto 0);

    signal alu_A, alu_B   : STD_LOGIC_VECTOR(3 downto 0);
    signal alu_Y          : STD_LOGIC_VECTOR(3 downto 0);
    signal alu_carry      : STD_LOGIC;
    signal alu_overflow   : STD_LOGIC;
    signal alu_zero       : STD_LOGIC;
    signal alu_active     : STD_LOGIC;

    signal read_sel_a     : STD_LOGIC_VECTOR(2 downto 0);
    signal read_sel_b     : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_sub        : STD_LOGIC;
    signal wb_sel_imm     : STD_LOGIC;
    signal pc_load        : STD_LOGIC;

    signal Z_flag      : STD_LOGIC;
    signal V_flag      : STD_LOGIC;
    signal flag_en     : STD_LOGIC;
    signal jzr_reg_value  : STD_LOGIC_VECTOR(3 downto 0);
    signal jzr_zero    : STD_LOGIC;

    signal enable  : std_logic := '0';

begin
    -- immediate and jump address extraction
    imm_val   <= instruction(3 downto 0);
    jump_addr <= instruction(2 downto 0);

    slow_clk : slow_clock
        port map (
            clk_in => Clk_100MHz,
            enable => enable );
    
    -- Program ROM
    u_rom: program_rom
        port map (
            addr => pc_addr,
            data => instruction
        );

    -- Instruction Decoder
    u_decoder: instruction_decoder
        port map (
            instruction    => instruction,
            zero_flag      => jzr_zero,
            reg_write_en   => reg_write_en,
            reg_write_sel  => reg_write_sel,
            read_sel_a     => read_sel_a,
            read_sel_b     => read_sel_b,
            alu_sub        => alu_sub,
            wb_sel_imm     => wb_sel_imm,
            pc_load        => pc_load
        );

    -- Program Counter
    u_pc: pc
        port map (
            clk       => Clk_100MHz,
            enable    => enable,
            reset     => reset,
            pc_load   => pc_load,
            jump_addr => jump_addr,
            pc_out    => pc_addr
        );
        
    -- flags
    u_flags : flags
        port map (
            clk      => Clk_100MHz,
            enable   => enable,
            reset    => reset,
            flag_en       => flag_en,
            alu_zero => alu_zero,
            alu_overflow => alu_overflow,
            Z        => Z_flag,
            V        => V_flag
        );

    -- Register Bank
    u_regbank: register_bank
        port map (
            clk        => Clk_100MHz,
            enable     => enable,
            reset      => reset,
            write_en   => reg_write_en,
            write_sel  => reg_write_sel,
            write_data => reg_write_data,
            R0         => R0,
            R1         => R1,
            R2         => R2,
            R3         => R3,
            R4         => R4,
            R5         => R5,
            R6         => R6,
            R7         => R7
        );

    -- 8-way mux for ALU input A
    u_muxA: mux8_4bit
        port map (
            sel => read_sel_a,
            I0  => R0, I1 => R1, I2 => R2, I3 => R3,
            I4  => R4, I5 => R5, I6 => R6, I7 => R7,
            Y   => alu_A
        );

    -- 8-way mux for ALU input B
    u_muxB: mux8_4bit
        port map (
            sel => read_sel_b,
            I0  => R0, I1 => R1, I2 => R2, I3 => R3,
            I4  => R4, I5 => R5, I6 => R6, I7 => R7,
            Y   => alu_B
        );

    -- Add/Subtract Unit
    u_alu: ADD_SUB_4bit
        port map (
            A        => alu_A,
            B        => alu_B,
            alu_sel  => alu_sub,
            Y        => alu_Y,
            carry    => alu_carry,
            overflow => alu_overflow,
            zero     => alu_zero
        );

    -- 2-way mux for writeback selection (ALU result vs immediate)
    u_wb_mux: mux2_4bit
        port map (
            sel => wb_sel_imm,
            A   => alu_Y,
            B   => imm_val,
            Y   => reg_write_data
        );

    -- Mux to get the register value for JZR zero test
    u_mux_jzr: mux8_4bit
        port map (
            sel => instruction(9 downto 7),
            I0  => R0, I1 => R1, I2 => R2, I3 => R3,
            I4  => R4, I5 => R5, I6 => R6, I7 => R7,
            Y   => jzr_reg_value
        );
    
    jzr_zero <= '1' when jzr_reg_value = "0000" else '0';
    flag_en <= reg_write_en and not wb_sel_imm;
    result <= R7;
    zero   <= Z_flag;
    overflow <= V_flag;

end Behavioral;