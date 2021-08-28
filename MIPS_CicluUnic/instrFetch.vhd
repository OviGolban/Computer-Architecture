----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2021 03:01:44 PM
-- Design Name: 
-- Module Name: instrFetch - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instrFetch is
port(clk:in std_logic;
    branchAddress: in std_logic_vector(15 downto 0);
    jumpAddress: in std_logic_vector(15 downto 0);
    jump: in std_logic;
    PCSrc: in std_logic;
    PCenable:in std_logic;
    reset: in std_logic;
    instruction:out std_logic_vector(15 downto 0);
    pc:out std_logic_vector(15 downto 0));
end instrFetch;

architecture Behavioral of instrFetch is
type rom_type is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom_memory:rom_type:=(B"000_000_000_001_0_000", --add $1,$0,$0
                             B"001_000_100_0001000",   --addi $4,$0,8
                             B"000_000_000_010_0_000", --add $2,$0,$0
                             B"000_000_000_101_0_000", --add $5,$0,$0
                             B"100_001_100_0001100",   --beq $1,$4,12
                             B"010_010_011_0101000",   --lw $e, 40($2)
                             B"001_011_011_0000001",   --addi $3,$3,1
                             B"011_010_011_0101000",   --sw $3,40($2)
                             B"000_101_011_101_0_000", --add $5,$5,$3
                             B"001_010_010_0000010",   --addi $2,$2,2
                             B"001_001_001_0000001",   --addi $1,$1,1
                             B"111_0000000000100",     -- j 4
                             B"011_000_101_1001000",   -- sw $5, 72($0)
                             others=>x"0000");
signal outMux1: std_logic_vector(15 downto 0);
signal outMux2: std_logic_vector(15 downto 0);
signal counter: std_logic_vector(15 downto 0);
signal outSumator: std_logic_vector(15 downto 0);
begin

process(clk,reset)
begin
    if(clk='1' and clk'event) then
       if(PCenable='1') then
          counter<=outMux2;
        end if;
    end if;
    if(reset='1') then
        counter<=x"0000";
    end if;
end process;
    
instruction<=rom_memory(conv_integer(counter(7 downto 0)));

outSumator<=counter+1;
pc<=counter+1;

process(outSumator,branchAddress,PCSrc)
begin
    if(PCSrc='0') then
        outMux1<=outSumator;
    else
        outMux1<=branchAddress;
    end if;
end process;

process(jumpAddress, jump, outMux2)
begin
    if(jump='0') then
        outMux2<=outMux1;
    else
        outMux2<=jumpAddress;
    end if;
end process;
    


end Behavioral;
