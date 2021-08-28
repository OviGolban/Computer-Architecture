----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2021 03:45:38 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal count:std_logic_vector(15 downto 0);
signal outMux1: std_logic_vector(3 downto 0);
signal outMux2: std_logic_vector(3 downto 0);
signal hex: std_logic_vector(3 downto 0);
--signal LED: std_logic_vector(6 downto 0);

begin
    process(clk)
    begin
        if(clk='1' and clk'event) then
            count <= count + 1;
        end if;
     end process;
     
     process(count,digit0,digit1,digit2,digit3)
     begin
        case count(15 downto 14) is
            when "00"=>outMux1<=digit0;
            when "01"=>outMux1<=digit1;
            when "10"=>outMux1<=digit2;
            when "11"=>outMux1<=digit3;
            when others=>outMux1<=(others=>'X');
        end case;
     end process;
     hex<=outMux1;
     
     process(count)
     begin
        case count(15 downto 14) is
            when "00"=>outMux2<="1110";
            when "01"=>outMux2<="1101";
            when "10"=>outMux2<="1011";
            when "11"=>outMux2<="0111";
            when others=>outMux2<=(others=>'X');
        end case;
     end process;
     an<=outMux2;
     
     with HEX Select
     cat<=  "1111001" when "0001", --1
            "0100100" when "0010", --2
            "0110000" when "0011", --3
            "0011001" when "0100", --4
            "0010010" when "0101",   --5
            "0000010" when "0110",   --6
            "1111000" when "0111",   --7
            "0000000" when "1000",   --8
            "0010000" when "1001",   --9
            "0001000" when "1010",   --A
            "0000011" when "1011",   --b
            "1000110" when "1100",   --C
            "0100001" when "1101",   --d
            "0000110" when "1110",   --E
            "0001110" when "1111",   --F
            "1000000" when others;   --0
        
     
     


end Behavioral;
